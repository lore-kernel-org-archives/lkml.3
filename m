Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbaGOLxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:53:35 -0400
Received: from mout.web.de ([212.227.15.4]:58151 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbaGOLxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:53:32 -0400
Message-ID: <53C51608.4080109@web.de>
Date: Tue, 15 Jul 2014 13:52:40 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>
CC: mtosatti@redhat.com, nadav.amit@gmail.com, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page
 in memory.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com> <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com> <20140712080442.GH4399@minantech.com> <53C38D55.2040307@cn.fujitsu.com> <20140714145822.GK4399@minantech.com>
In-Reply-To: <20140714145822.GK4399@minantech.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DtHITanR3VJulkIV9TaTaWcBIaWU2S0jt"
X-Provags-ID: V03:K0:njPLXlVhKOg/2+kXuxEjlGoIKCj8gS9d/Vrr2SCuOtN1XHq27MZ
 hnU+h2Tg1Sb9Y9+J7ZD6G0kZeiKVmmO1i/uz5GP4IkmWW4twD7jJGH3+4bBTlHs7WnGFxJQ
 jwXP8DzkuiaF+x/vyFySROZMsAoUKwleYCa9WGBKXUN4G3oC/pPcnrEx4JIdIdnmpH127KH
 xEin1gPcmkcwjRZrpaMBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DtHITanR3VJulkIV9TaTaWcBIaWU2S0jt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-07-14 16:58, Gleb Natapov wrote:
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index ffbe557..7080eda 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -5929,6 +5929,18 @@ static void vcpu_scan_ioapic(struct kvm_vcpu =
*vcpu)
>>>>  	kvm_apic_update_tmr(vcpu, tmr);
>>>>  }
>>>>
>>>> +static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	/*
>>>> +	 * When the page is being migrated, GUP will wait till the migrate=

>>>> +	 * entry is replaced with the new pte entry pointing to the new pa=
ge.
>>>> +	 */
>>>> +	struct page *page =3D gfn_to_page_no_pin(vcpu->kvm,
>>>> +					APIC_DEFAULT_PHYS_BASE>>  PAGE_SHIFT);
>>> If you do not use kvm->arch.apic_access_page to get current address w=
hy not drop it entirely?
>>>
>>
>> I should also update kvm->arch.apic_access_page here. It is used in ot=
her
>> places
>> in kvm, so I don't think we should drop it. Will update the patch.
> What other places? The only other place I see is in nested kvm code and=
 you can call
> gfn_to_page_no_pin() there instead of using kvm->arch.apic_access_page =
directly. But
> as far as I see nested kvm code cannot handle change of APIC_ACCESS_ADD=
R phys address.
> If APIC_ACCESS_ADDR changes during nested guest run, non nested vmcs wi=
ll still have old
> physical address. One way to fix that is to set KVM_REQ_APIC_PAGE_RELOA=
D during nested exit.

I cannot follow your concerns yet. Specifically, how should
APIC_ACCESS_ADDR (the VMCS field, right?) change while L2 is running? We
currently pin/unpin on L1->L2/L2->L1, respectively. Or what do you mean?

Jan



--DtHITanR3VJulkIV9TaTaWcBIaWU2S0jt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPFFgwACgkQitSsb3rl5xR6/ACg4nroWhrJtQB/9IVJh6PKEOhs
PvYAn1wKiG9aGZarsd3XRCwOfOo5v5Ag
=xpYu
-----END PGP SIGNATURE-----

--DtHITanR3VJulkIV9TaTaWcBIaWU2S0jt--
