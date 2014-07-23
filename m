Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaGWHwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:52:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaGWHwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:52:05 -0400
Message-ID: <53CF699D.9070902@canonical.com>
Date: Wed, 23 Jul 2014 09:51:57 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<20140709122953.11354.46381.stgit@patser>	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>	<53CE84AA.9030703@amd.com>	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de> <CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com> <53CF6622.6060803@amd.com>
In-Reply-To: <53CF6622.6060803@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 23-07-14 09:37, Christian König schreef:
> Am 23.07.2014 09:31, schrieb Daniel Vetter:
>> On Wed, Jul 23, 2014 at 9:26 AM, Christian König
>> <deathsimple@vodafone.de> wrote:
>>> It's not a locking problem I'm talking about here. Radeons lockup handling
>>> kicks in when anything calls into the driver from the outside, if you have a
>>> fence wait function that's called from the outside but doesn't handle
>>> lockups you essentially rely on somebody else calling another radeon
>>> function for the lockup to be resolved.
>> So you don't have a timer in radeon that periodically checks whether
>> progress is still being made? That's the approach we're using in i915,
>> together with some tricks to kick any stuck waiters so that we can
>> reliably step in and grab locks for the reset.
>
> We tried this approach, but it didn't worked at all.
>
> I already considered trying it again because of the upcoming fence implementation, but reconsidering that when a driver is forced to change it's handling because of the fence implementation that's just another hint that there is something wrong here.
As far as I can tell it wouldn't need to be reworked for the fence implementation currently, only the moment you want to allow callers outside of radeon. :-)
Doing a GPU lockup recovery in the wait function would be messy even right now, you would hit a deadlock in ttm_bo_delayed_delete -> ttm_bo_cleanup_refs_and_unlock.

Regardless of the fence implementation, why would it be a good idea to do a full lockup recovery when some other driver is
calling your wait function? That doesn't seem to be a nice thing to do, so I think a timeout is the best error you could return here,
other drivers have to deal with that anyway.

~Maarten

