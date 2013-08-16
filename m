Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3HPOCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:02:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:28448 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab3HPOCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:02:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,895,1367996400"; 
   d="scan'208";a="282840142"
Message-ID: <1376662051.2089.371.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1] ubi: remove and create MTD device back when UBI
 volume is resized
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Aug 2013 17:07:31 +0300
In-Reply-To: <1376306265-8671-1-git-send-email-Andrew.Rybchenko@oktetlabs.ru>
References: <1376306265-8671-1-git-send-email-Andrew.Rybchenko@oktetlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-12 at 15:17 +0400, Andrew Rybchenko wrote:
> If underlying MTD device size is simply corrected (as it was before),
> MTD block device is not notified about MTD device size change. As the
> result, for example, mount fails after create with zero size, resize,
> write file system image.
> 
> Side effect of the patch is change of MTD device number on resize/update.
> 
> Signed-off-by: Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>

Usually MTD devices never change their size, and the whole MTD subsystem
is implemented with this assumption, and the users of the MTD interface
have the same assumption - MTD devices do not size change their size.

So this change is fixing one problem by introducing another problem -
now not only the size may change, but the device number may change, and
even more ...

> +		gluebi_remove(&nt->vi);

... the device may just disappear for a while (not, the mtd mutex is
dropped here).

> +		gluebi_create(&nt->di, &nt->vi);

... then appear again in a different form :-)

When you remove the device, you also remove its sysfs files. And then
re-creates it. What an app keeps it open? Not big deal, it'll just get a
read error next time it reads it.

Anyway, this patch is not ideal.

I guess the right way to solve the problem would be to just prohibit
re-sizing a UBI volumes if we use gluebi.

Or just put the entire emulated MTD device to some "invalid" state if
the underlying UBI volume was resized. May be not always, but only if it
became smaller.

Or something else.

Anyway, I do acknowledge this is a problem, but I am not sure this is a
good solution...

-- 
Best Regards,
Artem Bityutskiy

