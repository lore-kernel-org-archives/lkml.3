Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBKWee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:34:34 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56696 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaBKWed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Feb 2014 14:34:11 -0800
Message-ID: <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
Subject: Re: Too many rescheduling interrupts (still!)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: multipart/mixed; boundary=089e01633aa85e24fb04f2290fa6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01633aa85e24fb04f2290fa6
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Feb 11, 2014 at 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 11 Feb 2014, Andy Lutomirski wrote:
>
> Just adding Peter for now, as I'm too tired to grok the issue right
> now.
>
>> Rumor has it that Linux 3.13 was supposed to get rid of all the silly
>> rescheduling interrupts.  It doesn't, although it does seem to have
>> improved the situation.
>>
>> A small number of reschedule interrupts appear to be due to a race:
>> both resched_task and wake_up_idle_cpu do, essentially:
>>
>> set_tsk_need_resched(t);
>> smb_mb();
>> if (!tsk_is_polling(t))
>>   smp_send_reschedule(cpu);
>>
>> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
>> is too quick (which isn't surprising if it was in C0 or C1), then it
>> could *clear* TS_POLLING before tsk_is_polling is read.
>>
>> Is there a good reason that TIF_NEED_RESCHED is in thread->flags and
>> TS_POLLING is in thread->status?  Couldn't both of these be in the
>> same field in something like struct rq?  That would allow a real
>> atomic op here.
>>
>> The more serious issue is that AFAICS default_wake_function is
>> completely missing the polling check.  It goes through
>> ttwu_queue_remote, which unconditionally sends an interrupt.

There would be an extra benefit of moving the resched-related bits to
some per-cpu structure: it would allow lockless wakeups.
ttwu_queue_remote, and probably all of the other reschedule-a-cpu
functions, could do something like:

if (...) {
  old = atomic_read(resched_flags(cpu));
  while(true) {
      if (old & RESCHED_NEED_RESCHED)
        return;
      if (!(old & RESCHED_POLLING)) {
        smp_send_reschedule(cpu);
        return;
      }
      new = old | RESCHED_NEED_RESCHED;
      old = atomic_cmpxchg(resched_flags(cpu), old, new);
  }
}

The point being that, with the current location of the flags, either
an interrupt needs to be sent or something needs to be done to prevent
rq->curr from disappearing.  (It probably doesn't matter if the
current task changes, because TS_POLLING will be clear, but what if
the task goes away entirely?)

All that being said, it looks like ttwu_queue_remote doesn't actually
work if the IPI isn't sent.  The attached patch appears to work (and
reduces total rescheduling IPIs by a large amount for my workload),
but I don't really think it's worthy of being applied...

--Andy

--089e01633aa85e24fb04f2290fa6
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-sched-Try-to-avoid-sending-an-IPI-in-ttwu_queue_remo.patch"
Content-Disposition: attachment; 
	filename="0001-sched-Try-to-avoid-sending-an-IPI-in-ttwu_queue_remo.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hrjqself0

RnJvbSA5ZGZhNmE5OWU1ZWI1YWIwYmMzYTRkNmJlYjU5OWJhMGYyZjYzM2FmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8OWRmYTZhOTllNWViNWFiMGJjM2E0ZDZiZWI1OTli
YTBmMmY2MzNhZi4xMzkyMTU3NzIyLmdpdC5sdXRvQGFtYWNhcGl0YWwubmV0PgpGcm9tOiBBbmR5
IEx1dG9taXJza2kgPGx1dG9AYW1hY2FwaXRhbC5uZXQ+CkRhdGU6IFR1ZSwgMTEgRmViIDIwMTQg
MTQ6MjY6NDYgLTA4MDAKU3ViamVjdDogW1BBVENIXSBzY2hlZDogVHJ5IHRvIGF2b2lkIHNlbmRp
bmcgYW4gSVBJIGluIHR0d3VfcXVldWVfcmVtb3RlCgpUaGlzIGlzIGFuIGV4cGVyaW1lbnRhbCBw
YXRjaC4gIEl0IHNob3VsZCBwcm9iYWJseSBub3QgYmUgYXBwbGllZC4KClNpZ25lZC1vZmYtYnk6
IEFuZHkgTHV0b21pcnNraSA8bHV0b0BhbWFjYXBpdGFsLm5ldD4KLS0tCiBrZXJuZWwvc2NoZWQv
Y29yZS5jIHwgMjQgKysrKysrKysrKysrKysrKysrLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWQv
Y29yZS5jIGIva2VybmVsL3NjaGVkL2NvcmUuYwppbmRleCBhODhmNGE0Li5mYzdiMDQ4IDEwMDY0
NAotLS0gYS9rZXJuZWwvc2NoZWQvY29yZS5jCisrKyBiL2tlcm5lbC9zY2hlZC9jb3JlLmMKQEAg
LTE0NzUsMjAgKzE0NzUsMjMgQEAgc3RhdGljIGludCB0dHd1X3JlbW90ZShzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnAsIGludCB3YWtlX2ZsYWdzKQogfQogCiAjaWZkZWYgQ09ORklHX1NNUAotc3RhdGlj
IHZvaWQgc2NoZWRfdHR3dV9wZW5kaW5nKHZvaWQpCitzdGF0aWMgdm9pZCBfX3NjaGVkX3R0d3Vf
cGVuZGluZyhzdHJ1Y3QgcnEgKnJxKQogewotCXN0cnVjdCBycSAqcnEgPSB0aGlzX3JxKCk7CiAJ
c3RydWN0IGxsaXN0X25vZGUgKmxsaXN0ID0gbGxpc3RfZGVsX2FsbCgmcnEtPndha2VfbGlzdCk7
CiAJc3RydWN0IHRhc2tfc3RydWN0ICpwOwogCi0JcmF3X3NwaW5fbG9jaygmcnEtPmxvY2spOwot
CiAJd2hpbGUgKGxsaXN0KSB7CiAJCXAgPSBsbGlzdF9lbnRyeShsbGlzdCwgc3RydWN0IHRhc2tf
c3RydWN0LCB3YWtlX2VudHJ5KTsKIAkJbGxpc3QgPSBsbGlzdF9uZXh0KGxsaXN0KTsKIAkJdHR3
dV9kb19hY3RpdmF0ZShycSwgcCwgMCk7CiAJfQorfQogCitzdGF0aWMgdm9pZCBzY2hlZF90dHd1
X3BlbmRpbmcodm9pZCkKK3sKKwlzdHJ1Y3QgcnEgKnJxID0gdGhpc19ycSgpOworCXJhd19zcGlu
X2xvY2soJnJxLT5sb2NrKTsKKwlfX3NjaGVkX3R0d3VfcGVuZGluZyhycSk7CiAJcmF3X3NwaW5f
dW5sb2NrKCZycS0+bG9jayk7CiB9CiAKQEAgLTE1MzYsOCArMTUzOSwxNSBAQCB2b2lkIHNjaGVk
dWxlcl9pcGkodm9pZCkKIAogc3RhdGljIHZvaWQgdHR3dV9xdWV1ZV9yZW1vdGUoc3RydWN0IHRh
c2tfc3RydWN0ICpwLCBpbnQgY3B1KQogewotCWlmIChsbGlzdF9hZGQoJnAtPndha2VfZW50cnks
ICZjcHVfcnEoY3B1KS0+d2FrZV9saXN0KSkKLQkJc21wX3NlbmRfcmVzY2hlZHVsZShjcHUpOwor
CXN0cnVjdCBycSAqcnEgPSBjcHVfcnEoY3B1KTsKKworCWlmIChsbGlzdF9hZGQoJnAtPndha2Vf
ZW50cnksICZycS0+d2FrZV9saXN0KSkgeworCQl1bnNpZ25lZCBsb25nIGZsYWdzOworCisJCXJh
d19zcGluX2xvY2tfaXJxc2F2ZSgmcnEtPmxvY2ssIGZsYWdzKTsKKwkJcmVzY2hlZF90YXNrKGNw
dV9jdXJyKGNwdSkpOworCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcnEtPmxvY2ssIGZs
YWdzKTsKKwl9CiB9CiAKIGJvb2wgY3B1c19zaGFyZV9jYWNoZShpbnQgdGhpc19jcHUsIGludCB0
aGF0X2NwdSkKQEAgLTI1MjUsNiArMjUzNSw4IEBAIG5lZWRfcmVzY2hlZDoKIAlzbXBfbWJfX2Jl
Zm9yZV9zcGlubG9jaygpOwogCXJhd19zcGluX2xvY2tfaXJxKCZycS0+bG9jayk7CiAKKwlfX3Nj
aGVkX3R0d3VfcGVuZGluZyhycSk7CisKIAlzd2l0Y2hfY291bnQgPSAmcHJldi0+bml2Y3N3Owog
CWlmIChwcmV2LT5zdGF0ZSAmJiAhKHByZWVtcHRfY291bnQoKSAmIFBSRUVNUFRfQUNUSVZFKSkg
ewogCQlpZiAodW5saWtlbHkoc2lnbmFsX3BlbmRpbmdfc3RhdGUocHJldi0+c3RhdGUsIHByZXYp
KSkgewotLSAKMS44LjUuMwoK
--089e01633aa85e24fb04f2290fa6--
