Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaIQI2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:28:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:20149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaIQI2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:28:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="592497353"
Message-ID: <1410942507.28850.78.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix possible deadlock in erase_worker()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Wed, 17 Sep 2014 11:28:27 +0300
In-Reply-To: <1410853702-11616-1-git-send-email-richard@nod.at>
References: <1410853702-11616-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 09:48 +0200, Richard Weinberger wrote:
> If sync_erase() failes with EINTR, ENOMEM, EAGAIN or
> EBUSY erase_worker() re-schedules the failed work.
> This will lead to a deadlock because erase_worker() is called
> with work_sem held in read mode. And schedule_erase() will take
> this lock again.

IIRC, the assumption was that the R/W semaphore may be taken in read
mode many times, so it wouldn't hurt to do:

down_read()
down_read()
up_read()
up_read()

If this is right, then the lockdep warning is incorrect.

-- 
Best Regards,
Artem Bityutskiy

