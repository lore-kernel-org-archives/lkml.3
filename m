Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBNLZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:25:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBNLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:25:07 -0500
Message-ID: <52FDFCFA.906@canonical.com>
Date: Fri, 14 Feb 2014 12:24:42 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FA6D4B.7020709@canonical.com> <20140211194553.GZ9987@twins.programming.kicks-ass.net> <52FB2EC8.4080602@canonical.com> <20140212103713.GE3545@laptop.programming.kicks-ass.net> <20140212104017.GA5121@pd.tnic> <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net> <52FCFA23.4060701@canonical.com> <20140213182522.GB14089@laptop.programming.kicks-ass.net>
In-Reply-To: <20140213182522.GB14089@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="CCi3e5t82wjM0rIwugFoWWd4OlQreLmsb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CCi3e5t82wjM0rIwugFoWWd4OlQreLmsb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 13.02.2014 19:25, Peter Zijlstra wrote:
> On Thu, Feb 13, 2014 at 06:00:19PM +0100, Stefan Bader wrote:
>> On 12.02.2014 12:54, Peter Zijlstra wrote:
>>> On Wed, Feb 12, 2014 at 12:09:29PM +0100, Stefan Bader wrote:
>>>> Something else here I run a kernel with CONFIG_PREEMPT not set and N=
R_CPUS
>>>> limited to 8 (for the 32bit kernel). So the default apic driver is u=
sed. Since
>>>> default_send_IPI_mask_logical is only used from there, I assume the =
trace you
>>>> got does the same. Maybe something there is wrong which would explai=
n why we
>>>> only see it on 32bit hosts.
>>>
>>> Can you try with a different APIC driver to test this?
>>>
>> I don't think I can. And I think the statement about this only be used=
 for 32bit
>> could be wrong. I got mislead to think so because those are only defin=
ed in
>> probe_32 but the 64bit counterpart isn't containing much aside that.
>>
>> Anyway, I played around with tracing a bit more. So with this change:
>>
>>                 if (need_resched()) {
>>                         srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>>                         if (need_resched() !=3D should_resched()) {
>> +                               trace_printk("need(%i) !=3D should(%i)=
\n",
>> +                                       need_resched(), should_resched=
());
>> +                               trace_printk("exit_reason=3D%u\n",
>> +                                       vcpu->run->exit_reason);
>> +                                trace_printk("preempt_count=3D%lx\n",=

>> +                                        __this_cpu_read_4(__preempt_c=
ount));
>> +                                tracing_stop();
>> +                                printk(KERN_ERR "Stopped tracing, due=
 to
>> inconsistent state.\n");
>>                         }
>>  +                      schedule();
>>  -                      cond_reschedule();
>>                         vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);=

>>                 }
>>
>> I get the following (weird) output:
>>
>>             Xorg-1078  [001] d...    71.270251: native_smp_send_resche=
dule
>> <-resched_task
>>             Xorg-1078  [001] d...    71.270251: default_send_IPI_mask_=
logical
>> <-native_smp_send_reschedule
>>       bamfdaemon-2318  [001] d...    71.270465: resched_task <-check_p=
reempt_wakeup
>>       bamfdaemon-2318  [001] d...    71.270539: resched_task <-check_p=
reempt_wakeup
>>           compiz-2365  [001] d...    71.270689: resched_task <-check_p=
reempt_wakeup
>>           compiz-2365  [001] d...    71.270827: resched_task <-check_p=
reempt_wakeup
>>           compiz-2365  [001] d...    71.270940: resched_task <-check_p=
reempt_wakeup
>>  qemu-system-x86-2679  [000] dn..    71.270999: smp_reschedule_interru=
pt
>> <-reschedule_interrupt
>>  qemu-system-x86-2679  [000] dn..    71.270999: scheduler_ipi
>> <-smp_reschedule_interrupt
>>  qemu-system-x86-2679  [000] .N..    71.271001: kvm_arch_vcpu_ioctl_ru=
n: need(1)
>> !=3D should(0)
>>  qemu-system-x86-2679  [000] .N..    71.271002: kvm_arch_vcpu_ioctl_ru=
n:
>> exit_reason=3D2
>>  qemu-system-x86-2679  [000] .N..    71.271003: kvm_arch_vcpu_ioctl_ru=
n:
>> preempt_count=3D0
>>
>> So am I reading this right, that the interrupt did get delivered to cp=
u#0 while
>> the thread info already had the resched flag set. So this really shoul=
d have
>> cleared the bit in preempt_count. But while the trace info shows 'N' f=
or some
>> reason should_reschedule returns false but at the same time reading th=
e preempt
>> count manually shows it 0?
>=20
> So the assembly merges the first and second should_resched(), so its
> possible that load got before the interrupt().
>=20
> The 3rd preempt_count load gets re-issued and so that would show the
> 'true' value again.
>=20
> If you want to force a reload after the condition; put in a barrier().
>=20
> In any case; this looks like a false-positive. Please try again until
> you get one where the interrupt doesn't happen and we stay in 'n' state=
=2E
>=20

Oh and one thing I was wondering. Not sure I do understand it right... Wh=
en
initially converting to percpu counts, you changed the 32bit assembly lik=
e that:

--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -362,12 +362,9 @@ END(ret_from_exception)
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
        DISABLE_INTERRUPTS(CLBR_ANY)
-       cmpl $0,TI_preempt_count(%ebp)  # non-zero preempt_count ?
-       jnz restore_all
 need_resched:
-       movl TI_flags(%ebp), %ecx       # need_resched set ?
-       testb $_TIF_NEED_RESCHED, %cl
-       jz restore_all
+       cmpl $0,PER_CPU_VAR(__preempt_count)
+       jnz restore_all
        testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)    # interrupts off (excepti=
on path
        jz restore_all
        call preempt_schedule_irq

This seems to say if preempt_count was 0 then then if the thread flag was=
 set
and interrupts were not off(?) it would do a preempt ipi and then come ba=
ck to
re-check the thread flag.
This would now be if preempt_count is 0 only... and I wonder whether that=
 would
change from doing that loop...


--CCi3e5t82wjM0rIwugFoWWd4OlQreLmsb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/fz6AAoJEOhnXe7L7s6jruIQANHTcdMqAxI0kADdF73GEB36
gRsW5tFJ/96qVNrD9PHnemj9pPMYHLWePvs1wTD+AcbLlWqLb4Pdkikvw02oB8q3
avSwjm2YzMYIEWNPJLEstthzrizo2alaiQ51uSBPB00EuPrzoL468Het2L9N9D4a
v2w8cg7AiTYNbYW3nAASTwiucBds8TY79+swMl5HUVOMzzsXphLwXsUErtxRdzZK
K5RbSzKDJ2CXrR3o4uAjSF7XGWAFdBJA8/uRXQt292tGGzjr3UmY6l/FnSVHnjCN
RXlLqGzfLITSqDRmeVYTfA7iBmDT/Ac/lWccqffUHUjaKFIhfMuoPnEtPbasS3Ok
B9NFnLw2Gi36QBfo0Z/ZC6yv3/lhk6GNSLXTklub+Vk7w7OyJnoXSPPbLhHdDO3r
QUfRRXdfQOFTeE0IfUfDrdDWcMgXn3y9ZFPN5vR8HtYj4Vy9x/lNeKq0pSEgLImd
osmYQxYBWpnuu3r9o+OKXNSOM17WzoQfU2mSHn1LXdICn/NxD/p77Bxta/0jeR3j
F+eCpl7fPbB4+Exk/Z898A+lIAEzcH2UjOhmvFDGlixNJzi3ymfW8/wH7T2uUmIp
VZFEBFJ+dKejW6lsWjiomTmmV7fxca9xc2aocvrMRC5Ohkm/siVj2MEF/WiSBGPi
HWq5UXZS5CHuVumbts0C
=Z1Xd
-----END PGP SIGNATURE-----

--CCi3e5t82wjM0rIwugFoWWd4OlQreLmsb--
