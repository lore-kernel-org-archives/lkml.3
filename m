Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaBNK4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:56:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaBNK4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:56:05 -0500
Message-ID: <52FDF61D.80709@canonical.com>
Date: Fri, 14 Feb 2014 11:55:25 +0100
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
 boundary="CT6tJXux0qxDl60O8GPxuP8t56vwErQ3m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CT6tJXux0qxDl60O8GPxuP8t56vwErQ3m
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
Ok, I think I now got a log of the actual issue. It seems cpu#1 missed ou=
t on
handling a reschedule interrupt but did send one to cpu#0 and on cpu#0 wh=
ile
handling the interrupt the tif flag was not set (yet?) but then when it i=
s,
there is no more interrupt to do the folding... (sorry for the wrapping).=
=2E.

 qemu-system-x86-2503  [000] d.h.  1145.887872: default_send_IPI_mask_log=
ical
<-native_smp_send_reschedule
 qemu-system-x86-2503  [000] d...  1145.887888: resched_task <-check_pree=
mpt_curr
          <idle>-0     [000] d.h.  1145.888001: resched_task <-check_pree=
mpt_curr
          <idle>-0     [001] dn..  1145.888788: smp_reschedule_interrupt
<-reschedule_interrupt
          <idle>-0     [001] dn..  1145.888789: scheduler_ipi
<-smp_reschedule_interrupt
  gnome-terminal-2440  [000] d...  1145.888957: resched_task <-check_pree=
mpt_curr
  gnome-terminal-2440  [000] d...  1145.888959: native_smp_send_reschedul=
e
<-resched_task
  gnome-terminal-2440  [000] d...  1145.888959: default_send_IPI_mask_log=
ical
<-native_smp_send_reschedule
          <idle>-0     [001] dn..  1145.889296: smp_reschedule_interrupt
<-reschedule_interrupt
          <idle>-0     [001] dn..  1145.889297: scheduler_ipi
<-smp_reschedule_interrupt
  gnome-terminal-2440  [000] d...  1145.889465: resched_task <-check_pree=
mpt_curr
  gnome-terminal-2440  [000] d...  1145.889467: native_smp_send_reschedul=
e
<-resched_task
  gnome-terminal-2440  [000] d...  1145.889467: default_send_IPI_mask_log=
ical
<-native_smp_send_reschedule
            Xorg-1054  [001] d.h.  1145.889469: resched_task <-check_pree=
mpt_wakeup
            Xorg-1054  [001] d.h.  1145.889469: native_smp_send_reschedul=
e
<-resched_task
            Xorg-1054  [001] d.h.  1145.889469: default_send_IPI_mask_log=
ical
<-native_smp_send_reschedule
 qemu-system-x86-2503  [000] d.s.  1145.889643: smp_reschedule_interrupt
<-reschedule_interrupt
 qemu-system-x86-2503  [000] d.s.  1145.889643: scheduler_ipi
<-smp_reschedule_interrupt
 qemu-system-x86-2503  [000] .n..  1145.889647: kvm_arch_vcpu_ioctl_run: =
sched
inconsistency
 qemu-system-x86-2503  [000] .n..  1145.889662: kvm_arch_vcpu_ioctl_run: =
sched
inconsistency
 qemu-system-x86-2503  [000] .n..  1145.889664: kvm_arch_vcpu_ioctl_run: =
sched
inconsistency
 qemu-system-x86-2503  [000] .n..  1145.889668: kvm_arch_vcpu_ioctl_run: =
need(1)
!=3D should(0)
 qemu-system-x86-2503  [000] .n..  1145.889669: kvm_arch_vcpu_ioctl_run:
exit_reason=3D2
 qemu-system-x86-2503  [000] .n..  1145.889669: kvm_arch_vcpu_ioctl_run:
preempt_count=3D80000000


--CT6tJXux0qxDl60O8GPxuP8t56vwErQ3m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/fYoAAoJEOhnXe7L7s6jag0P/3Ghj6GPtfChPYq4WVBRFSV+
nOa7k9xR6ykOIlRVORA1hZ9MflNQ1DDwr6cJHII0ekf9Jd6xv9O8P0j1kKq3c//j
DzKHZwCep8KSe6lYsNtR0i1F7+KAYR3p/CbFMvNX1SVI8mjLmd+DvCvQkdJKdojv
vgE+x7TenXTLkS3Y/DhH6CLgHu1HJ6AVBDSWVDJUz2ER311DiklHst4+/Vq4in5U
HTfWAG/4iC/FC748WmJW5htwO9aZBIPPITWEn1CHf1ew0Tcyv79GCw/1mNzOziue
vEuHktCe0nclFyILnyMF2bZ5BOSd20ZS8/fQ/msBCuV7jw3IWqHTQ6HRMc8fb05Y
j2MxSO7pMpySI55IXRIOX8Y6E2niAotTqiHC3rm63wHj//nPdw5MW6qwMYs5lP0z
UTff6/WmYSmNNg4ViVt0JzcdX56MnUq+GIBjQs7/y7uKxcgHdxBM+HEuxgNd9nax
gVM17bhwMJ1Ao9eHNuPTWHaIrqQw3NXcN0nlpbqdJYdHjjM8iMgfhPRNQadrOPmg
DbJz2f5H3xmrdrnLqreb74xyYdDT0S6CVnKBdyBwdy/JFOzsTozS4XRA6Yff0b+L
rcSk0TRP3bZ7zVdMC1LAhsVVg6Tqv6nyGB1/k6hY3aW4x8+85FUV1t+nK3bvaOWL
v+rD3x/dvIEJH/3vmuA8
=NHX1
-----END PGP SIGNATURE-----

--CT6tJXux0qxDl60O8GPxuP8t56vwErQ3m--
