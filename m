Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639Ab3DBNcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:32:17 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:60556 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860Ab3DBNcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:32:15 -0400
Date: Tue, 2 Apr 2013 08:31:18 -0500 (CDT)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Marco Munderloh <munderl@tnt.uni-hannover.de>
cc: Ilija Hadzic <ilijahadzic@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in
 drm_open in error path
In-Reply-To: <515AC8A1.1070901@tnt.uni-hannover.de>
Message-ID: <Pine.GSO.4.64.1304020809300.5951@umail>
References: <20130326195601.GA5124@dhcp22.suse.cz>
 <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
 <20130331103418.GA18476@dhcp22.suse.cz> <Pine.GSO.4.64.1304011249370.27674@umail>
 <515AB490.8010703@tnt.uni-hannover.de> <CA+4h6HkOSPUpfT-5Hwe+zRkmSdhURM6Tv4RxM+9PMCEvG+tjZw@mail.gmail.com>
 <515AC8A1.1070901@tnt.uni-hannover.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-1903590565-1364909478=:5951"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-1903590565-1364909478=:5951
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


Marco,

What makes you think that the crash after second modprobe is related to=20
the mappings pointers in DRM module? Can you actually establish the=20
correlation between these patches and the crash or you are just suspecting=
=20
because your other bug had something to do with module removal/insertion?

If it's the latter, then you may want to open another bug report here=20
https://bugs.freedesktop.org/ (use DRI for product and pick DRM/radeon for=
=20
component) and have this issue tracked and addressed separately.

The divide error that your log shows apparently happens at this line
inside r6xx_remap_render_backend:

pipe_rb_ratio =3D rendering_pipe_num / req_rb_num;

I would suspect that req_rb_num somehow evaluates to zero at the second=20
modprobe. That variable seems to be the derived of the last three=20
arguments to r6xx_remap_render_backend. If I look at the caller=20
(evergreen_gpu_init) the arguments that have the play here are all derived=
=20
from the GPU's hardware registers (or are the constant for a given GPU=20
device). So I suspect that the GPU driver leaves some state in GPU at=20
module removal that later bites you.

-- Ilija

On Tue, 2 Apr 2013, Marco Munderloh wrote:

> Hi Ilija,
>
>> Thanks for testing. Other issues are probably unrelated, so I'll send th=
e=20
>> last version of the patch to Dave.
>
> I came across another problem which seems related. rmmod radeon works,=20
> however, modprobe radeon afterwards results in a crash (divide error), se=
e=20
> attachment.
>
> Best, Marco
>
> On 02.04.2013 13:23, Ilija Hadzic wrote:
>>=20
>> -- Ilija
>>=20
>> On Tue, Apr 2, 2013 at 6:36 AM, Marco Munderloh=20
>> <munderl@tnt.uni-hannover.de <mailto:munderl@tnt.uni-hannover.de>> wrote=
:
>>
>>         Attached is a v2 of the patch, for reference. I would appreciate=
 if=20
>> the original reporter or you tested it in lieu of your proposed patch an=
d=20
>> let me know if it
>>         fixes your
>>         issue.
>>=20
>>
>>     The patch works for me. echo 3 > /proc/sys/vm/drop_caches as well as=
=20
>> rmmod radeon do not end up in a crash anymore. However, I have still no=
=20
>> clue why one of these makes
>>     drm_open to fail. On rmmod radeon I get the following log messages. =
If=20
>> don't know if the 'unpin not necessary' has anything to do with it.
>>
>>     [drm] radeon: finishing device.
>>     radeon 0000:01:00.0: ffff88024e526c00 unpin not necessary
>>     radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
>>     radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
>>     [TTM] Finalizing pool allocator
>>     [TTM] Finalizing DMA pool allocator
>>     [TTM] Zone  kernel: Used memory at exit: 0 kiB
>>     [TTM] Zone   dma32: Used memory at exit: 0 kiB
>>     [drm] radeon: ttm finalized
>>     vga_switcheroo: disabled
>>     [drm] Module unloaded
>>
>>     By the way, sometimes my r8169 ethernet controller does not survive=
=20
>> suspend/hibernation (does not detect link). rmmod/modprobe helps. I don'=
t=20
>> know if this is related.
>>=20
>>=20
>
> --=20
> Dipl.-Ing. Marco Munderloh             Mail: munderl@tnt.uni-hannover.de
> Institut f=FCr Informationsverarbeitung (TNT)     Phone: +49 511 762-1958=
7
> Leibniz Universitaet Hannover, Appelstr. 9a       Fax: +49 511 762- 5333
> 30167 Hannover, Germany     Web: http://www.tnt.uni-hannover.de/~munderl
>
---559023410-1903590565-1364909478=:5951--
