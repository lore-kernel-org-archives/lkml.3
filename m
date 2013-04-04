Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763284Ab3DDQiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:38:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52924 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763055Ab3DDQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:38:50 -0400
Message-ID: <1365093516.2609.109.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 18:38:36 +0200
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the
> wait
> times of older task.

No, imagine the following:

struct ww_mutex A, B;
struct mutex C;

	task-O	task-Y	task-X
	  	A
		B
			C
		C
	B

At this point O finds that Y owns B and thus we want to make Y 'yield'
B to make allow B progress. Since Y is blocked, we'll send a wakeup.
However Y is blocked on a different locking primitive; one that doesn't
collaborate in the -EDEADLK scheme therefore we don't want the wakeup to
succeed.



