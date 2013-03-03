Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3CCPjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 10:39:09 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43707 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CCPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 10:39:07 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
Date: Sun, 3 Mar 2013 19:39:05 +0400
X-Google-Sender-Auth: jBoN2BNCQEDn6VCDtxd-q6rwqIo
Message-ID: <CAAW1UO91=pCAMEBk4+JTp6_woy6o8Nc8b+85LgmwQxq_kGM+Bw@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 5:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Feb 25, 2013 at 4:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> Highlights:
>>
>> i915: all over the map, haswell power well enhancements, valleyview macro horrors cleaned up, killing lots of legacy GTT
>> code,
>
> Lowlight:
>
> There's something wrong with i915 DP detection or whatever. I get
> stuff like this:
>
> [    5.710827] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.720810] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.730794] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.740782] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.750775] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.750778] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f
> .....
> [    8.149931] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f


I have the same messages after upgrading up to
b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50
But in my case when I reboot computer the second monitor, that plugged
via HDMI, didn't works, end when I run `xrandr`, I have next messages
in kern.log

Mar  3 18:09:15 home-spb kernel: [12321.758273] [drm:intel_dp_aux_ch]
*ERROR* dp_aux_ch not done status 0xa143003f
Mar  3 18:09:15 home-spb kernel: [12321.771715]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!
Mar  3 18:09:15 home-spb kernel: [12321.782712]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!
Mar  3 18:09:15 home-spb kernel: [12321.793715]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!
Mar  3 18:09:15 home-spb kernel: [12321.804719]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!
Mar  3 18:09:15 home-spb kernel: [12321.815725]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!
Mar  3 18:09:15 home-spb kernel: [12321.817293] [drm:intel_dp_aux_ch]
*ERROR* dp_aux_ch not done status 0xa143003f

# lspci | fgrep -i graph
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09)

I tested some commits, and here the results:
- Breaked at v3.8-10206-gb0af9cd
- Works normal v3.8-rc3-139-g34f2be4
- Works normal v3.8-rc3-188-g10aa17c
- Works normal 6dc1c49

I've tested 0001-drm-i915-only-use-irq-for-dp-on-post-ilk.patch and it
works for me.
Thank, Dave.

>
> and after that the screen ends up black.
>
> It's happened twice now, but is not 100% repeatable. It looks like the
> message itself is new,  but the black screen is also new and does seem
> to happen when I get the message, so...
>
> The second time I touched the power button, and the machine came back.
> Apparently the suspend/resume cycle made it all magically work: the
> suspend caused the same errors, but then the resume made it all good
> again.
>
> Some kind of missed initialization at bootup? It's not reliable enough
> to bisect, but I obviously suspect commit 9ee32fea5fe8 ("drm/i915:
> irq-drive the dp aux communication") since that is where the message
> was added..
>
> Btw, looking at that commit, what do you think the semantics of the
> timeout in something like
>
>     done = wait_event_timeout(dev_priv->gmbus_wait_queue, C, 10);
>
> would be? What's that magic "10"? It's some totally random number.
>
> Guys, it should be something meaningful. If you meant a tenth of a
> second, use HZ/10 or something. Because just the plain "10" is crazy.
> I happen to have CONFIG_HZ_1000=y, and you're apparently waiting for a
> hundreth of a second. Was that what you intended? Because if it was,
> it is still crap, since CONFIG_HZ might be 100, and then you're
> waiting for ten times longer.
>
> IOW, passing in a random number like that is crazy. It cannot possibly
> be right.
>
> I have no idea whether the timeout has anything to do with anything,
> but it reinforces my suspicion that there is something wrong with that
> commit.
>
>                    Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Respectfully
Azat Khuzhin
Primary email a3at.mail@gmail.com
