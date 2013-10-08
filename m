Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3JHOpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:45:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3JHOpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:45:47 -0400
Message-ID: <52541A95.4040107@canonical.com>
Date: Tue, 08 Oct 2013 16:45:41 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH] drm/radeon: fixup locking inversion between mmap_sem
 and reservations
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232A39B.5040205@vmware.com> <52541350.5060807@canonical.com> <20131008143354.GA2355@gmail.com>
In-Reply-To: <20131008143354.GA2355@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 08-10-13 16:33, Jerome Glisse schreef:
> On Tue, Oct 08, 2013 at 04:14:40PM +0200, Maarten Lankhorst wrote:
>> Allocate and copy all kernel memory before doing reservations. This prevents a locking
>> inversion between mmap_sem and reservation_class, and allows us to drop the trylocking
>> in ttm_bo_vm_fault without upsetting lockdep.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> I would say NAK. Current code only allocate temporary page in AGP case.
> So AGP case is userspace -> temp page -> cs checker -> radeon ib.
>
> Non AGP is directly memcpy to radeon IB.
>
> Your patch allocate memory memcpy userspace to it and it will then be
> memcpy to IB. Which means you introduce an extra memcpy in the process
> not something we want.
>
Can we move up the call to radeon_ib_get then to be done before calling radeon_cs_parser_relocs?

~Maarten
