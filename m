Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3IHSHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 14:07:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3IHSHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 14:07:45 -0400
Date: Sun, 8 Sep 2013 20:01:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: free_pid() && PIDNS_HASH_ADDING
Message-ID: <20130908180137.GA4915@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com> <20130830144232.GA18281@mail.hallyn.com> <87hae6vh0w.fsf_-_@xmission.com> <20130908175602.GA3172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130908175602.GA3172@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Oleg Nesterov wrote:
>
> Off topic. What if the first alloc_pid() succeeds and then later
> copy_process() fails. In this case free_pid() is called but
> PIDNS_HASH_ADDING was not cleared, we miss kern_unmount(), no?

Perhaps something like below?

Oleg.

--- x/kernel/pid.c
+++ x/kernel/pid.c
@@ -272,6 +272,8 @@ void free_pid(struct pid *pid)
 			 */
 			wake_up_process(ns->child_reaper);
 			break;
+		case PIDNS_HASH_ADDING:
+			WARN_ON(ns->child_reaper);
 		case 0:
 			schedule_work(&ns->proc_work);
 			break;

