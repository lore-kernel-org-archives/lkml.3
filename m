Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaF3Mjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:39:55 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:51755 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbaF3Mjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:39:53 -0400
Message-ID: <53B15A94.3010402@vmware.com>
Date: Mon, 30 Jun 2014 14:39:48 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christopher Friedt <chrisfriedt@gmail.com>
CC: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com> <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com> <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com> <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com>
In-Reply-To: <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 02:25 PM, Christopher Friedt wrote:
> On Mon, Jun 30, 2014 at 7:48 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> I don't think we can blame video-vmware for this. A kernel driver change
>> that breaks existing user-space is by definition a kernel driver bug,
>> regardless whether exisiting user-space is doing something horrendously
>> stupid.
> I wouldn't be so quick to say it's a kernel bug. The fbdev contract
> hasn't changed. Also xf86-video-vmware isn't using the fbdev driver,
> and the fbdev driver code is obviously correct (see screenshots in
> link submitted with initial patch).

As I said. A kernel change that breaks existing user-space is ALWAYS BY
DEFINITION a kernel bug.
kernel changes are NOT ALLOWED to break existing user-space. The only
exception I can see here is if someone uses
the old non-kms driver which is not intended to work if vmware fbdev is
loaded but that's not the case here, from what I can tell?
>
>> So the fix must IMO be a kernel driver fix. My initial guess is that
>> once we set the bytes per line register, it might not be automatically
>> updated when the screen width is changed, but the documentation is poor.
>> I see if I can shed some light over this.
> Having dumped all of the svga registers while hacking on vmwgfx, I
> noticed that the BYTES_PER_LINE field is initially incorrectly set to
> something way off. My initial reaction is that video-vmware doesn't
> properly compute the bytes-per-line register, and therefore that it is
> a video-vmware bug that has always existed.

xf86-video-vmware in kms mode uses the kernel driver to set these registers.
FWIW, the modesetting part of the kernel driver uses SVGA_REG_PITCHLOCK
instead of
SVGA_REG_BYTES_PER_LINE to set the pitch. That's probably where the
clash happens.

/Thomas


>
> I'm reproducing the problem and providing a fix for video-vmware as I
> write this.
>
> C
