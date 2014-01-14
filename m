Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaANOQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:16:54 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:61470 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaANOQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140114134525.GA29558@localhost>
References: <20140114134525.GA29558@localhost>
Date: Tue, 14 Jan 2014 15:16:49 +0100
Message-ID: <CANq1E4QPXyU0iW3jNz7SJvQFxW5KjJ0EwGeDiv3LDFE4m8oMzg@mail.gmail.com>
Subject: Re: [drm] BUG: spinlock lockup suspected on CPU#0, swapper/0/1
From: David Herrmann <dh.herrmann@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Jan 14, 2014 at 2:45 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi David,
>
> I'm not sure if this is a good bisect because the errors are noisy,
> however it's good to inform you of this possibility.
>
> First bad commit may be a3483353c ("drm: check for !kdev in drm_unplug_minor()")

To be honest, I doubt that it's somehow related to this commit. We
replace "!device_is_registered(minor->kdev)" with a "!minor->kdev".
Both of these expressions have no side-effects (especially the latter
one) and they only evaluate to true during DRM unplugging. Having said
that, your log also contains this:

[   12.058502] [drm] Initialized drm 1.1.0 20060810
[   12.059918] [drm] radeon kernel modesetting enabled.
[   12.061791] [drm:cirrus_vram_init] *ERROR* can't reserve VRAM
[   12.063409] cirrus 0000:00:02.0: Fatal error during GPU init: -6
[   12.064914] Trying to free nonexistent resource <00000000febf0000-000000=
00febf0fff>

The DRM cirrus driver fails to load and given the error message I
suspect the error-path is not clean. Dave Airlie should know more
about cirrus, but I really think this is related to cirrus not
correctly cleaning up it's resources. Dave, any ideas? Disbling
CONFIG_CIRRUS should be a good workaround, in case anyone cares.

The commit in question highly reduces the required stack-space during
DRM unload (which includes the cirrus error-path) so I think the
bisect was alright, but the commit is not the actual culprit. It just
reveals some stack-corruption, I guess.

Thanks
David
