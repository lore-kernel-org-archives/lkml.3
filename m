Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaGWKwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:52:53 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:49580 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaGWKwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:52:51 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CF8AB1.2000009@amd.com>
References: <20140709093124.11354.3774.stgit@patser>
	<53CE8A57.2000803@vodafone.de>
	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>
	<53CF5EFE.6070307@canonical.com>
	<53CF63C2.7070407@vodafone.de>
	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>
	<53CF6622.6060803@amd.com>
	<53CF699D.9070902@canonical.com>
	<53CF6B18.5070107@vodafone.de>
	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>
	<53CF7035.2060808@amd.com>
	<53CF7191.2090008@canonical.com>
	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>
	<53CF765E.7020802@vodafone.de>
	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>
	<53CF8010.9060809@amd.com>
	<CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>
	<53CF822E.7050601@amd.com>
	<CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com>
	<53CF84C7.2020507@vodafone.de>
	<53CF8693.1040006@canonical.com>
	<53CF8AB1.2000009@amd.com>
Date: Wed, 23 Jul 2014 12:52:50 +0200
Message-ID: <CAKMK7uEgGzKb3Vsnz0FCgFCcSM39QntEisg0JMg=HOvnwLCZgw@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:13 PM, Christian König
<christian.koenig@amd.com> wrote:
>
>> And the dma-buf would still have fences belonging to both drivers, and it
>> would still call from outside the driver.
>
>
> Calling from outside the driver is fine as long as the driver can do
> everything necessary to complete it's work and isn't forced into any ugly
> hacks and things that are not 100% reliable.
>
> So I don't see much other approach as integrating recovery code for not
> firing interrupts and some kind of lockup handling into the fence code as
> well.

That approach doesn't really work at that well since every driver has
it's own reset semantics. And we're trying to move away from global
reset to fine-grained reset. So stop-the-world reset is out of
fashion, at least for i915. As you said, reset is normal in gpus and
we're trying to make reset less invasive. I really don't see a point
in imposing a reset scheme upon all drivers and I think you have about
as much motivation to convert radeon to the scheme used by i915 as
I'll have for converting to the one used by radeon. If it would fit at
all.

I guess for radeon we just have to add tons of insulation by punting
all callbacks to work items so that radeon can do whatever it wants.
Plus start a delayed_work based fallback when ->enable_signalling is
called to make sure we work on platforms that lack interrupts.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
