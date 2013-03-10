Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab3CJMit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:38:49 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50395 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3CJMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:38:48 -0400
Date: Sun, 10 Mar 2013 05:38:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 12/31] workqueue: update synchronization rules on
 workqueue->pwqs
Message-ID: <20130310123844.GE24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-13-git-send-email-tj@kernel.org>
 <513C5BD8.9050909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513C5BD8.9050909@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Mar 10, 2013 at 06:09:28PM +0800, Lai Jiangshan wrote:
> >  #define for_each_pwq(pwq, wq)						\
> > -	list_for_each_entry((pwq), &(wq)->pwqs, pwqs_node)
> > +	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
> > +		if (({ assert_rcu_or_wq_lock(); true; }))
> 
> Aware this:
> 
> if (somecondition)
> 	for_each_pwq(pwq, wq)
> 		one_statement;q
> else
> 	xxxxx;
> 
> 
> for_each_pwq() will eat the else.

Yeah, but that will also generate a compiler warning.

> To avoid this, you can use:
> 
> #define for_each_pwq(pwq, wq)						\
> 	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
> 		if (({ assert_rcu_or_wq_lock(); false; })) { }		\
> 		else
> 
> 
> The same for for_each_pool() in later patch.

Ooh, yeah, that's better.  Will do that.

Thanks.

-- 
tejun
