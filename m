Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3J1JUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:20:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39714 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3J1JUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:20:49 -0400
Message-ID: <526E2C59.5070907@jp.fujitsu.com>
Date: Mon, 28 Oct 2013 18:20:25 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: toshi.okajima@jp.fujitsu.com, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [BUG][PATCH] audit: audit_log_start running on auditd should
 not stop
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com>  <5257C5D7.80308@cn.fujitsu.com> <5257EF15.6080209@jp.fujitsu.com>  <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com>  <525CE10A.90907@cn.fujitsu.com>  <20131023195550.GA9109@madcap2.tricolour.ca>  <5269CB06.5060101@jp.fujitsu.com> <1382713941.2954.19.camel@flatline.rdu.redhat.com>
In-Reply-To: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

(2013/10/26 0:12), Eric Paris wrote:
> On Fri, 2013-10-25 at 10:36 +0900, Toshiyuki Okajima wrote:
> 
>> systemd                                    |auditd
>> -------------------------------------------+-----------------------------------
>> ...                                        |
>> -> audit_receive                           |...
>>    -> mutex_lock(&audit_cmd_mutex)         |-> audit_receive
>>       ... -> audit_log_start               |   -> mutex_lock(&audit_cmd_mutex)
>>              -> wait_for_auditd            |      // wait for systemd
>>                 -> schedule_timeout(60*HZ) |
> 

> Ugggh, definitely a problem.  Adding a similar hack to systemd really
> does not seem like an acceptable answer.  It seems to me that in
I think so, too. We should fix it against the various cases.

> audit_receive_msg()
> 
> case AUDIT_USER:
> case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
> case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
> 
> we do not need to hold the audit_cmd_mutex.  So a quick and dirty patch
> should be to just drop the mutex there (and we need to verify there
> aren't issues running the audit_filter_user() without the lock).  That
> will take care of systemd and anything USING audit.  It still means that
> you could race with something configuring audit and auditd shutting
> down.  Seems like a good quick and dirty 'fix' while we work on a better
> fix...
> 
> To take care of that I think maybe we could drop the cmd_mutex every
> time we call audit_log_start.  That's not necessarily going to be
> pretty.  Maybe make a new switch at the top of the function which knows
> which operations we are going to have to allocate an audit_buffer.  Drop
> the lock, allocate the buffer, then retake the lock to finish running
> audit_receive_msg()....
> 

> Maybe that second option isn't so hard and we can go directly after that
> instead of just dealing with userspace audit messages?
> 
> Thoughts?
Does it mean that we can also fix the problem only in the userspace? 

Even if we fix userspace process (auditd, readahead-collector and systemd) only, 
the problem would happen again if a new userspace audit process is implemented.
Therefore, I think we should fix only in the kernel.
Sorry, but I don't have clear method to fix it.

Regards,
Toshiyuki Okajima

> 
> 
> 



