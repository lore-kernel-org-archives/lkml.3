Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3JYPMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3JYPMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:12:30 -0400
Message-ID: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
Subject: Re: [BUG][PATCH] audit: audit_log_start running on auditd should
 not stop
From: Eric Paris <eparis@redhat.com>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Date: Fri, 25 Oct 2013 11:12:21 -0400
In-Reply-To: <5269CB06.5060101@jp.fujitsu.com>
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com>
	 <5257C5D7.80308@cn.fujitsu.com> <5257EF15.6080209@jp.fujitsu.com>
	 <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com>
	 <525CE10A.90907@cn.fujitsu.com>
	 <20131023195550.GA9109@madcap2.tricolour.ca>
	 <5269CB06.5060101@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 10:36 +0900, Toshiyuki Okajima wrote:

> systemd                                    |auditd
> -------------------------------------------+-----------------------------------
> ...                                        |
> -> audit_receive                           |...
>    -> mutex_lock(&audit_cmd_mutex)         |-> audit_receive
>       ... -> audit_log_start               |   -> mutex_lock(&audit_cmd_mutex)
>              -> wait_for_auditd            |      // wait for systemd
>                 -> schedule_timeout(60*HZ) |

Ugggh, definitely a problem.  Adding a similar hack to systemd really
does not seem like an acceptable answer.  It seems to me that in
audit_receive_msg()

case AUDIT_USER:
case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:

we do not need to hold the audit_cmd_mutex.  So a quick and dirty patch
should be to just drop the mutex there (and we need to verify there
aren't issues running the audit_filter_user() without the lock).  That
will take care of systemd and anything USING audit.  It still means that
you could race with something configuring audit and auditd shutting
down.  Seems like a good quick and dirty 'fix' while we work on a better
fix...

To take care of that I think maybe we could drop the cmd_mutex every
time we call audit_log_start.  That's not necessarily going to be
pretty.  Maybe make a new switch at the top of the function which knows
which operations we are going to have to allocate an audit_buffer.  Drop
the lock, allocate the buffer, then retake the lock to finish running
audit_receive_msg()....

Maybe that second option isn't so hard and we can go directly after that
instead of just dealing with userspace audit messages?

Thoughts?

