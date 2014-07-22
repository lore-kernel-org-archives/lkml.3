Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaGVQnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:43:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46623 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbaGVQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:43:07 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CAKMK7uFugmw_pP1nyA1ws5tMB6iCe1CqBHeWHoYzQ0wXE301EA@mail.gmail.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>
	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>
	<CAKMK7uFugmw_pP1nyA1ws5tMB6iCe1CqBHeWHoYzQ0wXE301EA@mail.gmail.com>
Date: Tue, 22 Jul 2014 18:43:07 +0200
Message-ID: <CAKMK7uHda2bsSG4Rsjb+=McYo50J0sS4vGqJ0R==ajc9HbqV7Q@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 6:21 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> But like I've said fence->signaled is optional so you don't need this
> necessarily, as long as radeon eventually calls fence_signaled once
> the fence has completed.

Actually I've chatted a bit with Maarten about the different ways we
could restrict both the calling context and the implementations for
fence callbacks to avoid surprises. One is certainyl that we need
WARN_ON(in_interrupt) around the wait, enable_singaling and add
callback stuff.

But we also talked about ensure that the ->signaled callback never
sleeps by wrapping it in a preempt_enable/disable section. Currently
sleeping is allowed in ->signaled, which the radeon implementation
here does. I think it would be reasonable to forbid this and drop
__radeon_fence_signaled.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
