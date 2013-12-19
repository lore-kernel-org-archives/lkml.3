Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3LSPbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:31:42 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43656 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3LSPbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:31:39 -0500
Message-ID: <52B31158.3030801@linux.com>
Date: Thu, 19 Dec 2013 16:31:36 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/38] workqueue: add missing put_device call
References: <1387465429-3568-2-git-send-email-levex@linux.com> <1387465429-3568-22-git-send-email-levex@linux.com> <20131219152044.GB16994@htj.dyndns.org>
In-Reply-To: <20131219152044.GB16994@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 04:20 PM, Tejun Heo wrote:
> Umm... this doesn't look right.  You're basically converting the code
> to the following,
> 
> 	x = kmalloc();
> 	if (register(x) < 0)
> 		put(x)
> 
> They're not symmetrical anymore.  register(), or any API call really,
> isn't supposed to have side effects which need explicit cleanup after
> a failure.  The fact that x is properly initialized even after
> register(x) failed is a coincidental implementation detail which
> shouldn't be depended upon.  Your patch is actively breaking the
> convention for no good reason.
> 
>  Nacked-by: Tejun Heo <tj@kernel.org>
> 
>>From the patch title, I suppose you posted a bunch of patches towards
> this direction.  Please consider all of them nacked if they're doing
> the same thing.
> 
> Thanks.
> 

The reason I removed the kfree() was because the put_device() will decrement
wq_dev->dev's reference count to zero (it is set to one by device_register) and hence the
wq_device_release() will be called. Now, this effectively does the same the kfree() call
would have done but also driver core is notified.

Also, if you take a look at the comment for the device_register() function, it explicitly
says NOT to kfree the struct device, but instead call put_device() and let the device's release()
function take care.

-- 
Regards,
Levente Kurusa
