Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab3FDIjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:39:06 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33242 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3FDIjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:39:01 -0400
X-AuditID: 85900ec0-d42c9b900000151e-35-51ada79e8bf1
Message-ID: <51ADA785.4000904@hitachi.com>
Date: Tue, 04 Jun 2013 17:38:29 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [EXAMPLE] tools: a tool for merging trace data of a guest and a host
References: <20130604083616.22713.24922.stgit@yunodevel>
In-Reply-To: <20130604083616.22713.24922.stgit@yunodevel>
Content-Type: multipart/mixed;
 boundary="------------020608000205000004030504"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020608000205000004030504
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This tool merges trace data of a guest and a host in chronological
order. Restrictions of this tool is as follows:
- one guest (not for multiple guests)
- stable TSC (not backward TSC)
- synchronized TSC
- unchanged TSC offset (the guest does not execute write_TSC)

- How to use
1. [host] Enable kvm_write_tsc_offset before booting a guest
      # cd /sys/kernel/debug/tracing/instances
      # mkdir tsc_offset
      # cd tsc_offset
      # echo x86-tsc > trace_clock
      # echo 1 > events/kvm/kvm_write_tsc_offset/enable

2. [host] Enable events you want
       Note: I recommend to enable kvm_exit/entry events.
      # cd /sys/kernel/debug/tracing
      # echo kvm_entry >> set_event
      # echo kvm_exit >> set_event
      # [snip]
      # echo x86-tsc > trace_clock

3. [host] Boot the guest

4. [guest] Enable events you want
      # cd /sys/kernel/debug/tracing
      # echo sched_wakeup >> set_event
      # echo sched_switch >> set_event
      # [snip]
      # echo x86-tsc > trace_clock

5. [guest] Run programs

6. [guest/host] Get trace data
      # echo 0 > tracing_on
      # cat trace > /home/yourdir/log/guest_trace.txt (for the guest)
        (cat trace > /home/yourdir/log/host_trace.txt (for the host))
      # scp [host_IP]:/home/yourdir/log/guest_trace.txt (only for the guest)

7. [host] Get next TSC offset
      # cat /sys/kernel/debug/tracing/instances/tsc_offset/trace
     qemu-kvm-22089 [000] d...4300151845072: kvm_write_tsc_offset: 
previous 0 next 18446739773557710924

8. [host] Run this tool with the next TSC offset for -t option.
$ ./trace-merge.pl -g ~/log/guest_trace.txt -h ~/log/host_trace.txt \
   -t 18446739773557710924

h        qemu-kvm-2687  [003] d...50550079203669: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079206816: kvm_entry: [detail]
g            comm-3826  [000] d.h.50550079226331: sched_wakeup: [detail]
h        qemu-kvm-2687  [003] d...50550079240656: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079243467: kvm_entry: [detail]
h        qemu-kvm-2687  [003] d...50550079256103: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079268391: kvm_entry: [detail]
g            comm-3826  [000] d...50550079279266: sched_switch: [detail]
h        qemu-kvm-2687  [003] d...50550079280829: kvm_exit: [detail]
h        qemu-kvm-2687  [003] d...50550079286028: kvm_entry: [detail]
|
\----guest/host

Thanks,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



--------------020608000205000004030504
Content-Type: text/plain; charset=Shift_JIS;
 name="trace-merge.pl"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="trace-merge.pl"

IyEvdXNyL2Jpbi9wZXJsCiMKIyBUb29sIGZvciBtZXJnaW5nIGFuZCBzb3J0aW5nIHRyYWNl
IGRhdGEgb2YgYSBndWVzdCBhbmQgaG9zdAojCiMgQ3JlYXRlZCBieSBZb3NoaWhpcm8gWVVO
T01BRSA8eW9zaGloaXJvLnl1bm9tYWUuZXpAaGl0YWNoaS5jb20+CiMKIyAtIEhvdyB0byB1
c2UKIyAuL3RyYWNlLW1lcmdlLnBsIDwtaCBob3N0X2RhdGEgLWcgZ3Vlc3RfZGF0YSAtdCB0
c2Nfb2Zmc2V0X3ZhbHVlPgojCnVzZSBzdHJpY3Q7CnVzZSBiaWdpbnQ7CnVzZSB3YXJuaW5n
czsKdXNlIEdldG9wdDo6TG9uZyBxdyg6Y29uZmlnIHBvc2l4X2RlZmF1bHQgbm9faWdub3Jl
X2Nhc2UpOwoKbXkgQG1lcmdlZF9kYXRhID0gKCk7Cm15IEBzb3J0ZWRfZGF0YSA9ICgpOwoK
bXkgKCRvcHRfaG9zdCwgJG9wdF9ndWVzdCwgJG9wdF9vZmZzZXQpOwpHZXRPcHRpb25zKAoJ
Imhvc3RfZGF0YXxoPXMiCT0+IFwkb3B0X2hvc3QsCgkiZ3Vlc3RfZGF0YXxnPXMiPT4gXCRv
cHRfZ3Vlc3QsCgkidHNjX29mZnNldHx0PWkiPT4gXCRvcHRfb2Zmc2V0Cik7CgpteSAkdHNj
X29mZnNldCA9IDA7Cm15ICRNQVNLNjQgPSAoMSA8PCA2NCkgLSAxOwoKJmdldF90c2Nfb2Zm
c2V0KCk7CiZyZWFkX2FsbF9kYXRhKCk7CgpzdWIgcmVhZF9hbGxfZGF0YSB7CglteSAkaF90
c2MgPSAwOwoJbXkgJGdfY29tbSA9ICIiOwoJbXkgJGdfdHNjID0gMDsKCW15ICRnX2V2ZW50
ID0gIiI7CglteSAkaF9saW5lID0gIiI7CglteSAkZ19saW5lID0gIiI7CgoJb3BlbiBIT1NU
X0RBVEEsICI8IiwgJG9wdF9ob3N0IG9yIGRpZSAiQ2Fubm90IG9wZW4gaG9zdCBmaWxlOiAk
ISI7CglvcGVuIEdVRVNUX0RBVEEsICI8IiwgJG9wdF9ndWVzdCBvciBkaWUgIkNhbm5vdCBv
cGVuIGd1ZXN0IGZpbGU6ICQhIjsKCgkjIHNraXAgaGVhZGVyIGluZm9ybWF0aW9uIG9mIHRy
YWNlIGZpbGVzCgl3aGlsZSAoISRoX3RzYykgewoJCSRoX2xpbmUgPSA8SE9TVF9EQVRBPjsK
CQlpZiAoJGhfbGluZSA9fiAvXFtbMC05XStcXVxzLns0fVxzKFswLTldKyk6LykgewoJCQkk
aF90c2MgPSAkMTsKCQl9Cgl9CgoJIyBza2lwIGhlYWRlciBpbmZvcm1hdGlvbiBvZiB0cmFj
ZSBmaWxlcwoJd2hpbGUgKCEkZ190c2MpIHsKCQkkZ19saW5lID0gPEdVRVNUX0RBVEE+OwoJ
CWlmICgkZ19saW5lID1+IC9eKC4rXFtbMC05XStcXVxzLns0fVxzKShbMC05XSspKDouKykv
KSB7CgkJCSRnX2NvbW0gPSAkMTsKCQkJJGdfdHNjID0gKCQyIC0gJHRzY19vZmZzZXQpICYg
JE1BU0s2NDsKCQkJJGdfZXZlbnQgPSAkMzsKCQl9Cgl9CgoJIyBzb3J0IHRyYWNlIGRhdGEg
YnkgdHNjCgl3aGlsZSAoJGhfbGluZSkgewoJCWlmICgkaF90c2MgPCAkZ190c2MpIHsKCQkJ
cHJpbnQgImggJGhfbGluZSI7CgkJCSRoX2xpbmUgPSA8SE9TVF9EQVRBPjsKCQkJaWYgKCEk
aF9saW5lKSB7CgkJCQlsYXN0OwoJCQl9CgkJCWlmICgkaF9saW5lID1+IC9cW1swLTldK1xd
XHMuezR9XHMoWzAtOV0rKTovKSB7CgkJCQkkaF90c2MgPSAkMTsKCQkJfQoJCX0gZWxzZSB7
CgkJCXByaW50ICJnICRnX2NvbW0kZ190c2MkZ19ldmVudFxuIjsKCQkJJGdfbGluZSA9IDxH
VUVTVF9EQVRBPjsKCQkJaWYgKCEkZ19saW5lKSB7CgkJCQlsYXN0OwoJCQl9CgkJCWlmICgk
Z19saW5lID1+IC9eKC4rXFtbMC05XStcXVxzLns0fVxzKShbMC05XSspKDouKykvKSB7CgkJ
CQkkZ19jb21tID0gJDE7CgkJCQkkZ190c2MgPSAoJDIgLSAkdHNjX29mZnNldCkgJiAkTUFT
SzY0OwoJCQkJJGdfZXZlbnQgPSAkMzsKCQkJfQoJCX0KCX0KCgkjZmx1c2ggaG9zdCBkYXRh
Cgl3aGlsZSAoJGhfbGluZSkgewoJCXByaW50ICJoICRoX2xpbmUiOwoJCSRoX2xpbmUgPSA8
SE9TVF9EQVRBPjsKCQlpZiAoISRoX2xpbmUpIHsKCQkJbGFzdDsKCQl9Cgl9CgoJI2ZsdXNo
IGd1ZXN0IGRhdGEKCXdoaWxlICgkZ19saW5lKSB7CgkJcHJpbnQgImcgJGdfY29tbSRnX3Rz
YyRnX2V2ZW50XG4iOwoJCSRnX2xpbmUgPSA8R1VFU1RfREFUQT47CgkJaWYgKCEkZ19saW5l
KSB7CgkJCWxhc3Q7CgkJfQoJCWlmICgkZ19saW5lID1+IC9eKC4rXFtbMC05XStcXVxzLns0
fVxzKShbMC05XSspKDouKykvKSB7CgkJCSRnX2NvbW0gPSAkMTsKCQkJJGdfdHNjID0gKCQy
IC0gJHRzY19vZmZzZXQpICYgJE1BU0s2NDsKCQkJJGdfZXZlbnQgPSAkMzsKCQl9Cgl9CgoJ
Y2xvc2UgSE9TVF9EQVRBOwoJY2xvc2UgR1VFU1RfREFUQTsKfQoKc3ViIGdldF90c2Nfb2Zm
c2V0IHsKCWlmICghJG9wdF9vZmZzZXQpIHsKCQkkdHNjX29mZnNldCA9IDA7Cgl9IGVsc2Ug
ewoJCSR0c2Nfb2Zmc2V0ID0gJmNvbnZlcnRfdHNjb2Zmc2V0KCRvcHRfb2Zmc2V0KTsKCX0K
fQoKc3ViIGNvbnZlcnRfdHNjb2Zmc2V0IHsKCW15ICRvZmZzZXQgPSBzaGlmdDsKCglyZXR1
cm4gJG9mZnNldCAtICgxIDw8IDY0KTsKfQo=
--------------020608000205000004030504--
