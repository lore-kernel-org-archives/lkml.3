Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161792AbaDPPXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:23:32 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58649 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161661AbaDPPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:23:29 -0400
Date: Wed, 16 Apr 2014 11:23:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
Message-ID: <20140416152326.GG1257@htj.dyndns.org>
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com>
 <5335661E.7030408@cn.fujitsu.com>
 <20140415164752.GC30990@htj.dyndns.org>
 <534DDBFC.9060803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DDBFC.9060803@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Apr 16, 2014 at 09:25:16AM +0800, Lai Jiangshan wrote:
> 1) Our aim is to protect unbound pwq, not percpu pwq which can't be be protected by get_pwq().
> 2) get_pwq() will make reviewers confused/surprised, destroy_workqueue() may destroy percpu pwqs
>    with ref > 1. At least we need to add more comments explain this behavior. Origin comments:
> 		/*
> 		 * The base ref is never dropped on per-cpu pwqs.  Directly
> 		 * free the pwqs and wq.
> 		 */

You can just comment "pwqs might go away at any time, pin it until
rescuer is done with it" and that's actually the better way to do it.
percpu wq's not supporting attribute changes may change in the future.
What the code path wants is pinning down the pwq no matter where it
came from.  There's no point in distinguishing unbound and per-cpu
here.

> 3) get_unbound_pwq() self document.

Not really.  If the name is get_pwq_if_unbound(), maybe.  Functions
which take args and become noop depending on the argument aren't
generally good ideas.  There are specific cases that they are suitable
but this is just gratuituous.

Thanks.

-- 
tejun
