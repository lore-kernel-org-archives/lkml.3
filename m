Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3EOJdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:33:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab3EOJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:33:07 -0400
Message-ID: <5193564C.20308@canonical.com>
Date: Wed, 15 May 2013 11:33:00 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        zhenzhong.duan@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tamon Shiose <tamon.shiose@oracle.com>, Feng Jin <joe.jin@oracle.com>
Subject: Re: [Xen-devel] [PATCH-v2] xen: Don't call arch_trigger_all_cpu_backtrace
 in dom0(pvm)
References: <51610A25.4010301@oracle.com> <5162911202000078000CB38E@nat28.tlf.novell.com>
In-Reply-To: <5162911202000078000CB38E@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigCAC581A375D95D3F9DB3D966"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCAC581A375D95D3F9DB3D966
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08.04.2013 09:42, Jan Beulich wrote:
>>>> On 07.04.13 at 07:54, Zhenzhong Duan <zhenzhong.duan@oracle.com> wro=
te:
>> nmi isn't supported in dom0, fallback to general all cpu backtrace cod=
e.
>=20
> Since when is sending NMIs not supported, and since when is this
> Dom0-specific? If you want to deal with this, you should do so
> properly: Special case sending NMIs in the respective Xen specific
> code (using VCPUOP_send_nmi), and carry this out in a way not
> dependent upon running (un)privileged.

FWIW, it seems different because PVM domU's end up using noop_apic, only =
dom0
seems to use the xen replacements for sending IPIs through apic->...
And the last time I looked there was no maping from NMI_VECTOR to a Xen
vector/handler.

>=20
>> Without fix, on xAPIC system, doing sysrq+l, no backtrace is showed,
>> as xen_send_IPI_all is called and it doesn't support nmi vector.
>>
>> On x2APIC enabled system, got NULL pointer dereference as below.
>>
>>     SysRq : Show backtrace of all active CPUs
>>     BUG: unable to handle kernel NULL pointer dereference at          =
 (null)
>>     IP: [<ffffffff8125e3cb>] memcpy+0xb/0x120
>>     Call Trace:
>>      [<ffffffff81039633>] ? __x2apic_send_IPI_mask+0x73/0x160
>>      [<ffffffff8103973e>] x2apic_send_IPI_all+0x1e/0x20
>>      [<ffffffff8103498c>] arch_trigger_all_cpu_backtrace+0x6c/0xb0
>>      [<ffffffff81501be4>] ? _raw_spin_lock_irqsave+0x34/0x50
>>      [<ffffffff8131654e>] sysrq_handle_showallcpus+0xe/0x10
>>      [<ffffffff8131616d>] __handle_sysrq+0x7d/0x140
>>      [<ffffffff81316230>] ? __handle_sysrq+0x140/0x140
>>      [<ffffffff81316287>] write_sysrq_trigger+0x57/0x60
>>      [<ffffffff811ca996>] proc_reg_write+0x86/0xc0
>>      [<ffffffff8116dd8e>] vfs_write+0xce/0x190
>>      [<ffffffff8116e3e5>] sys_write+0x55/0x90
>>      [<ffffffff8150a242>] system_call_fastpath+0x16/0x1b
>>
>> That's because apic points to apic_x2apic_cluster or apic_x2apic_phys
>> but the basic element like cpumask isn't initialized.
>=20
> That's of course a bug on its own, fixing of which would go under
> a suitable subject/title.
>=20
>> -v2: Mask x2APIC feature in pvm to avoid overwrite of apic pointer,
>>      update commit message per Konrad's suggestion.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> Tested-by: Tamon Shiose <tamon.shiose@oracle.com>
>> ---
>>  arch/x86/xen/enlighten.c |    3 +++
>>  include/linux/nmi.h      |    2 ++
>>  2 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index c8e1c7b..12b0718 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -386,6 +386,9 @@ static void __init xen_init_cpuid_mask(void)
>>  		cpuid_leaf1_edx_mask &=3D
>>  			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
>>  			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
>> +
>> +	cpuid_leaf1_ecx_mask &=3D ~(1 << (X86_FEATURE_X2APIC % 32));
>> +
>=20
> Bottom line - while this part may be fine (under a different title), ..=
=2E
>=20
>>  	ax =3D 1;
>>  	cx =3D 0;
>>  	xen_cpuid(&ax, &bx, &cx, &dx);
>> diff --git a/include/linux/nmi.h b/include/linux/nmi.h
>> index db50840..b845757 100644
>> --- a/include/linux/nmi.h
>> +++ b/include/linux/nmi.h
>> @@ -32,6 +32,8 @@ static inline void touch_nmi_watchdog(void)
>>  #ifdef arch_trigger_all_cpu_backtrace
>>  static inline bool trigger_all_cpu_backtrace(void)
>>  {
>> +	if (xen_domain())
>> +		return false;
>=20
> ... this part clearly isn't.
>=20
> Jan
>=20
>>  	arch_trigger_all_cpu_backtrace();
>> =20
>>  	return true;
>=20
>=20
>=20
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>=20



--------------enigCAC581A375D95D3F9DB3D966
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRk1ZMAAoJEOhnXe7L7s6jq9wQAJo8CIw4hVOUOPxn+fWaTa3C
cB3uQRha/atfuD0mJKzrx9S8ilefGgAYfmpqzUgDGQpetw8dUzOhST9RHWAAj+eJ
DUug9I1IAYF03mU6oP7TqlMuyBE47gW6w5LqkPy7u9V9JRWq6CvYdikVLhST48Ed
qL4oQHHhLzsDEAzDlprN5d4E+Ti0wx7CHH2t9Ez6s8DfgbxrfRXEwBaSFbDFpIA7
ZfPzPy4q8XLoKrPfgPftghAMiZzy/suwbUJ11t4p0SiXUXBuuxxbZQnsZKWPzAur
mmt5OSoEO4Pn5vzlsQmM1e+ME6I3c5/ilijV00Q1G953R7CMZSNwRIfWgWm7P9V5
TzjiQZJs2hoPoBcYkmz7LoBtVd5M4QU61o4UzW45ZHu86DdnW5dfcjLtYoySbyPG
MIWjFEOR5BkVVYrl6egKIGPV8uPyq27KwL+jhiDT+XLfjxYwiwTScaSXm8wopJf6
EImcbXj6BvU31TZZp+LxTWflt4rEK+SaA3MdljO5YzAZR1zIbQ0P9IDT7J8VolWR
ciJbVoTl9vtpTnhwuWhsZxhrZW/nhmIxj9eodZWBiktvZphQDb/WcETBpfKm5yje
GHtoLvqO8sGrj0axhwuLpDLRWpcBrykIt3nNEXlJD1T99MXRKcBg9pD1jpxj5pHx
aKnWZt+7ohTPpT5GwbwJ
=5i90
-----END PGP SIGNATURE-----

--------------enigCAC581A375D95D3F9DB3D966--
