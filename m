Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456Ab3DBNsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:48:41 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:40246 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3DBNsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.GSO.4.64.1304020809300.5951@umail>
References: <20130326195601.GA5124@dhcp22.suse.cz>
	<CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
	<20130331103418.GA18476@dhcp22.suse.cz>
	<Pine.GSO.4.64.1304011249370.27674@umail>
	<515AB490.8010703@tnt.uni-hannover.de>
	<CA+4h6HkOSPUpfT-5Hwe+zRkmSdhURM6Tv4RxM+9PMCEvG+tjZw@mail.gmail.com>
	<515AC8A1.1070901@tnt.uni-hannover.de>
	<Pine.GSO.4.64.1304020809300.5951@umail>
Date: Tue, 2 Apr 2013 09:48:38 -0400
Message-ID: <CADnq5_O7T83MC9HFyVow1j4V6=nLR9cd+OfWs1=fpD24sADUbg@mail.gmail.com>
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in
 drm_open in error path
From: Alex Deucher <alexdeucher@gmail.com>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Marco Munderloh <munderl@tnt.uni-hannover.de>,
        Michal Hocko <mhocko@suse.cz>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 9:31 AM, Ilija Hadzic
<ihadzic@research.bell-labs.com> wrote:
>
> Marco,
>
> What makes you think that the crash after second modprobe is related to the
> mappings pointers in DRM module? Can you actually establish the correlation
> between these patches and the crash or you are just suspecting because your
> other bug had something to do with module removal/insertion?
>
> If it's the latter, then you may want to open another bug report here
> https://bugs.freedesktop.org/ (use DRI for product and pick DRM/radeon for
> component) and have this issue tracked and addressed separately.
>
> The divide error that your log shows apparently happens at this line
> inside r6xx_remap_render_backend:
>
> pipe_rb_ratio = rendering_pipe_num / req_rb_num;
>
> I would suspect that req_rb_num somehow evaluates to zero at the second
> modprobe. That variable seems to be the derived of the last three arguments
> to r6xx_remap_render_backend. If I look at the caller (evergreen_gpu_init)
> the arguments that have the play here are all derived from the GPU's
> hardware registers (or are the constant for a given GPU device). So I
> suspect that the GPU driver leaves some state in GPU at module removal that
> later bites you.

Newer kernels have a fix for this.
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f689e3acbd2e48cc4101e0af454193f81af4baaf

Alex

>
> -- Ilija
>
> On Tue, 2 Apr 2013, Marco Munderloh wrote:
>
>> Hi Ilija,
>>
>>> Thanks for testing. Other issues are probably unrelated, so I'll send the
>>> last version of the patch to Dave.
>>
>>
>> I came across another problem which seems related. rmmod radeon works,
>> however, modprobe radeon afterwards results in a crash (divide error), see
>> attachment.
>>
>> Best, Marco
>>
>> On 02.04.2013 13:23, Ilija Hadzic wrote:
>>>
>>>
>>> -- Ilija
>>>
>>> On Tue, Apr 2, 2013 at 6:36 AM, Marco Munderloh
>>> <munderl@tnt.uni-hannover.de <mailto:munderl@tnt.uni-hannover.de>> wrote:
>>>
>>>         Attached is a v2 of the patch, for reference. I would appreciate
>>> if the original reporter or you tested it in lieu of your proposed patch and
>>> let me know if it
>>>         fixes your
>>>         issue.
>>>
>>>
>>>     The patch works for me. echo 3 > /proc/sys/vm/drop_caches as well as
>>> rmmod radeon do not end up in a crash anymore. However, I have still no clue
>>> why one of these makes
>>>     drm_open to fail. On rmmod radeon I get the following log messages.
>>> If don't know if the 'unpin not necessary' has anything to do with it.
>>>
>>>     [drm] radeon: finishing device.
>>>     radeon 0000:01:00.0: ffff88024e526c00 unpin not necessary
>>>     radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
>>>     radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
>>>     [TTM] Finalizing pool allocator
>>>     [TTM] Finalizing DMA pool allocator
>>>     [TTM] Zone  kernel: Used memory at exit: 0 kiB
>>>     [TTM] Zone   dma32: Used memory at exit: 0 kiB
>>>     [drm] radeon: ttm finalized
>>>     vga_switcheroo: disabled
>>>     [drm] Module unloaded
>>>
>>>     By the way, sometimes my r8169 ethernet controller does not survive
>>> suspend/hibernation (does not detect link). rmmod/modprobe helps. I don't
>>> know if this is related.
>>>
>>>
>>
>> --
>> Dipl.-Ing. Marco Munderloh             Mail: munderl@tnt.uni-hannover.de
>> Institut für Informationsverarbeitung (TNT)     Phone: +49 511 762-19587
>> Leibniz Universitaet Hannover, Appelstr. 9a       Fax: +49 511 762- 5333
>> 30167 Hannover, Germany     Web: http://www.tnt.uni-hannover.de/~munderl
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
