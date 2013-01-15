Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3AOPuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:50:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:33481 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757244Ab3AOPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:50:20 -0500
Date: Tue, 15 Jan 2013 10:50:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PM / Runtime: Fix the twice judgement in rpm_suspend/resume()
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A20400F@SHSMSX101.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1301151044560.6514-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Liu, Chuansheng wrote:

> > Indeed, this patch introduces a race.  If runtime_status changes from
> > RPM_SUSPENDING and power.wait_queue is signalled in between the test at
> > the end of the loop and the prepare_to_wait() call, the loop will never
> > end.
> Checking the race case, it should not happen?
> Updating runtime_status and wake_up wait_queue are protected by power.lock.
> spin_lock(&power.lock)
> ...
> __update_runtime_status()
> ...
> wake_up_all(&dev->power.wait_queue)
> ...
> spin_unlock(&power.lock)

You're right, the lock prevents this race from happening.

On the other hand, with your change we would end up calling finish_wait()
without calling prepare_to_wait() first.  And as Rafael mentioned, the
current code fits the pattern that people expect to see.

Alan Stern

