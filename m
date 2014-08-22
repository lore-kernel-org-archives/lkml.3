Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaHVJVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:21:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaHVJVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:21:11 -0400
Message-ID: <53F70B72.7030407@canonical.com>
Date: Fri, 22 Aug 2014 11:20:50 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel
 3.16)
References: <53E4B281.5050302@canonical.com>	<53E4C5D5.2090103@citrix.com>	<53E4E042.1070300@canonical.com>	<CAGXu5jJ+FTqgYpLH5x0VBm9QMND-b0Sze6q6pc=tRe2oFMu5uA@mail.gmail.com>	<53EA5782.1080301@canonical.com>	<CAGXu5jJXHd9WqWs+FHQsRZdJNv1n075q7rwm20EwwXBdVgaVsA@mail.gmail.com>	<20140812190726.GC13996@laptop.dumpdata.com> <CAGXu5jJFkdgaSs=5eWczWW5f3Gbr_-GLf3r_VXHq4z3rULVo_A@mail.gmail.com>
In-Reply-To: <CAGXu5jJFkdgaSs=5eWczWW5f3Gbr_-GLf3r_VXHq4z3rULVo_A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Gcscjn5KuS6pROlKKdIpAwjvmeiCQV32l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Gcscjn5KuS6pROlKKdIpAwjvmeiCQV32l
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 21.08.2014 18:03, Kees Cook wrote:
> On Tue, Aug 12, 2014 at 2:07 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
>> On Tue, Aug 12, 2014 at 11:53:03AM -0700, Kees Cook wrote:
>>> On Tue, Aug 12, 2014 at 11:05 AM, Stefan Bader
>>> <stefan.bader@canonical.com> wrote:
>>>> On 12.08.2014 19:28, Kees Cook wrote:
>>>>> On Fri, Aug 8, 2014 at 7:35 AM, Stefan Bader <stefan.bader@canonica=
l.com> wrote:
>>>>>> On 08.08.2014 14:43, David Vrabel wrote:
>>>>>>> On 08/08/14 12:20, Stefan Bader wrote:
>>>>>>>> Unfortunately I have not yet figured out why this happens, but c=
an confirm by
>>>>>>>> compiling with or without CONFIG_RANDOMIZE_BASE being set that w=
ithout KASLR all
>>>>>>>> is ok, but with it enabled there are issues (actually a dom0 doe=
s not even boot
>>>>>>>> as a follow up error).
>>>>>>>>
>>>>>>>> Details can be seen in [1] but basically this is always some por=
tion of a
>>>>>>>> vmalloc allocation failing after hitting a freshly allocated PTE=
 space not being
>>>>>>>> PTE_NONE (usually from a module load triggered by systemd-udevd)=
=2E In the
>>>>>>>> non-dom0 case this repeats many times but ends in a guest that a=
llows login. In
>>>>>>>> the dom0 case there is a more fatal error at some point causing =
a crash.
>>>>>>>>
>>>>>>>> I have not tried this for a normal PV guest but for dom0 it also=
 does not help
>>>>>>>> to add "nokaslr" to the kernel command-line.
>>>>>>>
>>>>>>> Maybe it's overlapping with regions of the virtual address space
>>>>>>> reserved for Xen?  What the the VA that fails?
>>>>>>>
>>>>>>> David
>>>>>>>
>>>>>> Yeah, there is some code to avoid some regions of memory (like ini=
trd). Maybe
>>>>>> missing p2m tables? I probably need to add debugging to find the f=
ailing VA (iow
>>>>>> not sure whether it might be somewhere in the stacktraces in the r=
eport).
>>>>>>
>>>>>> The kernel-command line does not seem to be looked at. It should p=
ut something
>>>>>> into dmesg and that never shows up. Also today's random feature is=
 other PV
>>>>>> guests crashing after a bit somewhere in the check_for_corruption =
area...
>>>>>
>>>>> Right now, the kaslr code just deals with initrd, cmdline, etc. If
>>>>> there are other reserved regions that aren't listed in the e820, it=
'll
>>>>> need to locate and skip them.
>>>>>
>>>>> -Kees
>>>>>
>>>> Making my little steps towards more understanding I figured out that=
 it isn't
>>>> the code that does the relocation. Even with that completely disable=
d there were
>>>> the vmalloc issues. What causes it seems to be the default of the up=
per limit
>>>> and that this changes the split between kernel and modules to 1G+1G =
instead of
>>>> 512M+1.5G. That is the reason why nokaslr has no effect.
>>>
>>> Oh! That's very interesting. There must be some assumption in Xen
>>> about the kernel VM layout then?
>>
>> No. I think most of the changes that look at PTE and PMDs are are all
>> in arch/x86/xen/mmu.c. I wonder if this is xen_cleanhighmap being
>> too aggressive
>=20
> (Sorry I had to cut our chat short at Kernel Summit!)
>=20
> I sounded like there was another region of memory that Xen was setting
> aside for page tables? But Stefan's investigation seems to show this
> isn't about layout at boot (since the kaslr=3D0 case means no relocatio=
n
> is done). Sounds more like the split between kernel and modules area,
> so I'm not sure how the memory area after the initrd would be part of
> this. What should next steps be, do you think?

Maybe layout, but not about placement of the kernel. Basically leaving KA=
SLR
enabled but shrink the possible range back to the original kernel/module =
split
is fine as well.

I am bouncing between feeling close to understand to being confused. Konr=
ad
suggested xen_cleanhighmap being overly aggressive. But maybe its the oth=
er way
round. The warning that occurs first indicates that PTE that was obtained=
 for
some vmalloc mapping is not unused (0) as it is expected. So it feels rat=
her
like some cleanup has *not* been done.

Let me think aloud a bit... What seems to cause this, is the change of th=
e
kernel/module split from 512M:1.5G to 1G:1G (not exactly since there is 8=
M
vsyscalls and 2M hole at the end). Which in vaddr terms means:

Before:
ffffffff80000000 - ffffffff9fffffff (=3D512 MB)  kernel text mapping, fro=
m phys 0
ffffffffa0000000 - ffffffffff5fffff (=3D1526 MB) module mapping space

After:
ffffffff80000000 - ffffffffbfffffff (=3D1024 MB) kernel text mapping, fro=
m phys 0
ffffffffc0000000 - ffffffffff5fffff (=3D1014 MB) module mapping space

Now, *if* I got this right, this means the kernel starts on a vaddr that =
is
pointed at by:

PGD[510]->PUD[510]->PMD[0]->PTE[0]

In the old layout the module vaddr area would start in the same PUD area,=
 but
with the change the kernel would cover PUD[510] and the module vaddr + vs=
yscalls
and the hole would cover PUD[511].

xen_cleanhighmap operates only on the kernel_level2_pgt which (speculatin=
g a bit
since I am not sure I understand enough details) I believe is the one PMD=

pointed at by PGD[510]->PUD[510]. That could mean that before the change
xen_cleanhighmap may touch some (the initial 512M) of the module vaddr sp=
ace but
not after the change. Maybe that also means it always should have covered=
 more
but this would not be observed as long as modules would not claim more th=
an
512M? I still need to check the vaddr ranges for which xen_cleanhighmap i=
s
actually called. The modules vaddr space would normally not be touched (o=
nly
with DEBUG set). I moved that to be unconditionally done but then this mi=
ght be
of no use when it needs to cover a different PMD...

Really not sure here. But maybe a starter for others...

-Stefan

>=20
> -Kees
>=20
>=20
>>>
>>> -Kees
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>>>
>>> _______________________________________________
>>> Xen-devel mailing list
>>> Xen-devel@lists.xen.org
>>> http://lists.xen.org/xen-devel
>=20
>=20
>=20



--Gcscjn5KuS6pROlKKdIpAwjvmeiCQV32l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT9wuDAAoJEOhnXe7L7s6j46UP/2zAtzzywAz9tLng5xoR0piW
TYm4NihAjL8gwhbut4M4H+XN+GjB7GV1fPjDi4bhLhsR+LJUN7cEPDOmnwVpjyTG
p4KWh5mX9ApT8AY85yTb4tIV9aMHUvRSnoBbWLozgLOqcyvVchDRV6acs3clEfPR
SgZk8xHk3O2dP0kj5dpEpknjnz9OVGY7FRhGpmUXmlZViYPX0AorfCW3WmgtI1sO
1O6CJUEV8BPPtt7g7cF2UvNRIECRaPFuV1m65AYXMDRKL5+kV24lc7gb0vfD1NHN
gnzOm88seb051Vw33nmnDfdnm4d24kgOmc2BNeIYulZ16NjHt8DG9kNKJpbURwg1
jpdlRwmD7HU/2ukBwbWVoPxe6Qz/hAxE2ez9Tddyi6rpul8LXf4/EYRNAJy7ZVRf
OKQJLmwQAJ92/hCz8f9Wq0kH/ntFKPocqdu/6rgxa+rtHCqNJjuEccHxG9NtX2CY
3nWFSR/shkUz/ZcMH7YIjQ4xsyk3WYL1nUm8MJ3aZKFlyM7kT/YI+egzsZb9oBEB
tQZVuZR1qd+XXBnMmB/eKXWWZjGKj2u1Z2sIDSGs26yjSME+aBTiNFH8bYUyf4/g
VEQzz1va18BrB5AyiTKtcjXmV8uFMZXtjxHBOnOAHthzJkP0fL7Srzg9ntYbjXDy
/1JhgRuUxLQnk3YWz46R
=XYyL
-----END PGP SIGNATURE-----

--Gcscjn5KuS6pROlKKdIpAwjvmeiCQV32l--
