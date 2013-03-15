Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3COS5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:57:39 -0400
Received: from che.mayfirst.org ([209.234.253.108]:42977 "EHLO
	che.mayfirst.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3COS5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:57:33 -0400
From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
To: Corey Minyard <minyard@mvista.com>, Corey Minyard <minyard@acm.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux IPMI subsystem hang
In-Reply-To: <87ip4w2g2e.fsf@alice.fifthhorseman.net>
References: <87ip4w2g2e.fsf@alice.fifthhorseman.net>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 15 Mar 2013 14:57:27 -0400
Message-ID: <87vc8s7ap4.fsf@alice.fifthhorseman.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue 2013-03-12 22:23:37 -0400, Daniel Kahn Gillmor wrote:

> I am working with a Lenovo ThinkCentre M78, model 4865-A14, and it seems
> to have trouble with the IPMI subsystem.
>
> udev seems to hang for about 3 minutes at startup, ultimately failing
> with the following messages:
>
> udevd[416]: worker [495] unexpectedly returned with status 0x0100
> udevd[416]: worker [495] failed while handling '/devices/pci0000:00/0000:=
00:15.2/0000:03:00.3'
>
> This hang happens whether i'm running linux kernel 3.2 or 3.8, using
> either x86 or x86_64 kernels.

trying with udev 175-7.1 (from debian unstable) and kernel 3.2, i see
that the failure message is:

udevd[548]: timeout: killing '/sbin/modprobe -b pci:v000010ECd0000816Csv000=
017AAsd00003089bc0Csc07i01' [623]

and:

[    5.650931] ipmi message handler version 39.2
[    5.916958] IPMI System Interface driver.
[    5.921153] ipmi_si 0000:03:00.3: probing via PCI
[    5.925851] ipmi_si 0000:03:00.3: [io  0xe000-0xe0ff] regsize 1 spacing =
1 irq 17
[    5.933727] ipmi_si: Adding PCI-specified kcs state machine
[    5.939554] ipmi_si: Trying PCI-specified kcs state machine at i/o addre=
ss 0xe000, slave address 0x0, irq 17
[  406.916061] ipmi_si: There appears to be no BMC at this location

with kernel 3.8, the last line ("There appears to be no BMC at this
location") isn't emitted, but the delay/hang with modprobe still
happens.

I think the first alias in ipmi_si.ko is what is causing this to be trigger=
ed:

0 krazy:~# modinfo ipmi_si | grep ^alias
alias:          pci:v*d*sv*sd*bc0Csc07i*
alias:          pci:v0000103Cd0000121Asv*sd*bc*sc*i*
0 krazy:~#=20

since the bc0Csc07 matches the [0c07] identifier from lspci:

> 03:00.3 IPMI SMIC interface [0c07]: Realtek Semiconductor Co., Ltd. Devic=
e [10ec:816c] (rev 01) (prog-if 01)

It seems like there are four plausible cases:

 0) this is actually an IPMI device, but the hardware is broken.

 1) this is an IPMI device, but it does not implement some part of the
    IPMI spec that ipmi_si.ko expects to be implemented, and ipmi_si.ko
    cannot detect this cleanly.

 2) this device is not an IPMI device at all, and is mislabeled in its
    PCI identifiers somehow.

 3) this device is not an IPMI device at all, it is properly labeled,
    and the module's internal aliasing (and lspci's index?) is
    overgeneral and misidentifies the device.

How can i distinguish between these cases?

> I am not subscribed to LKML, so please CC me on any replies.

Regards,

        --dkg

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQJ8BAEBCgBmBQJRQ28XXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQjk2OTEyODdBN0FEREUzNzU3RDkxMUVB
NTI0MDFCMTFCRkRGQTVDAAoJEKUkAbEb/fpcsCkP/1Y+Kv8AaSMv6TQpiTO920+S
rdO8VgZ28nTs8/fWxSkZFpWkKGFxSnonqsFxCWHiNbsJspNPZwwr3uAlFYHtm4fZ
fxFZx+BiS3r15F/GhodbRaMJzWAdu05nPENK+aRrQusCL+rQQ/KDOKZITu7Zijvk
XSD27lZ4n2+j7pKdbWpaM6qbU93J3F9VzeNwHpQ2pUiuaKGCGdJp929722ABxVts
U2O75ehg/KlMHtQu80ttTg8Ve49JCvO4SvZNthBDKm74vOX3heLexnOJiLMGuwgy
upnpsY2u7g062RHY1ESoPJiDknYMilmkFLWE4YSFilVxgJvDFMqa6vwhO05o9fIp
N4hsNgp1cvWhAQBmzouSYyc5q09TXvx0UTxcZFO4YzgXjpRZXzqsHcmO92dnx5MT
nGt4uSGkKyVVbdOvbkP83RzwcfhVpNyu7H1CXUNo09DZCZ2jgu250Gk/1ted/RWY
yhAyK49dvJcCpRhEs3puLYDwJIR7ZlAUkyTVWFflN0PjFy+h7/TyvISjsuemLB42
Dk9bmxcb7WoOTfR+cKdFg2MJI7XQfnUevxVh9R8OGAGUi4Yk4yvaz1bc10PU5Q21
hRyc/Dzwr9DVaLHuBSaMe4gLoPoDwLu6RZuLtYm+vl0/o2h2PO5bDaZVXWeCXzs6
LSdshox5AvbAHdG/aR+W
=FWIX
-----END PGP SIGNATURE-----
--=-=-=--
