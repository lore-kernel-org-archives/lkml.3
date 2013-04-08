Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923Ab3DHKA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:00:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54490 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934889Ab3DHKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:00:57 -0400
Message-ID: <1365415249.2609.145.camel@laptop>
Subject: Re: [RFC PATCH] sched: wake-affine throttle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 08 Apr 2013 12:00:49 +0200
In-Reply-To: <514FDF76.2060806@linux.vnet.ibm.com>
References: <514FDF76.2060806@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-25 at 13:24 +0800, Michael Wang wrote:
>         if (affine_sd) {
> -               if (cpu != prev_cpu && wake_affine(affine_sd, p,
> sync))
> +               if (cpu != prev_cpu && wake_affine(affine_sd, p,
> sync)) {
> +                       /*
> +                        * wake_affine() stuff try to pull wakee to
> the cpu
> +                        * around waker, this will benefit us if the
> data
> +                        * cached on waker cpu is hot for wakee, or
> the extreme
> +                        * ping-pong case.
> +                        *
> +                        * However, do such blindly work too
> frequently will
> +                        * cause regression to some workload, thus,
> each time
> +                        * when wake_affine() succeed, throttle it for
> a while.
> +                        */
> +                       wake_affine_throttle(p);
>                         prev_cpu = cpu;
> +               }

How about only throttling when wake_affine() starts returning false? At
that point its lost its benefit.

Also, why not place this inside wake_affine() like you did the throttled
test.

