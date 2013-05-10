Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3EJJv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:51:26 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9752 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EJJvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:51:25 -0400
X-Spam-Score: -100.8
Message-ID: <518CC2EA.8080604@asianux.com>
Date: Fri, 10 May 2013 17:50:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: audit_tree: resource management: need put_tree
 and goto Err when failure occures
References: <517110BA.5070806@asianux.com> <20130422160409.471f6208099a972d26c29fb9@linux-foundation.org> <518B9C32.7050408@asianux.com> <20130509131108.8a70aa5116ff0e3c250feb8b@linux-foundation.org> <518C568E.2040203@asianux.com>
In-Reply-To: <518C568E.2040203@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 10:08 AM, Chen Gang wrote:
> On 05/10/2013 04:11 AM, Andrew Morton wrote:
>>>> >> > For me, after 'rule->tree = NULL', all things seems fine !!
>> > Well, what was wrong before?  Is there some user-triggerable
>> > misbehaviour which you observed?  If so, please describe it.
>> > 
>> > 
>> > 

Oh, sorry, after have a test, the original code is no issue (it is my
fault).

When the deleting work flow call evict_chunk(), I assume that the
'postponed' can be NULL (at least, in some condition, it can), so
kill_rules() can be called directly. But in fact, 'postponed' will
never be NULL:

  audit_tree depend on CONFIG_AUDIT_TREE which depend on CONFIG_AUDITSYSCALL.
  if CONFIG_AUDITSYSCALL defined.
    do_fork() -> copy_process() -> audit_alloc() -> alloc 'audit_context'.
    so the audit_killed_tree() will return valid pointer to 'postponed'.

  although already have quite a few code for 'postponed == NULL', they are really useless now.

I also read all other work flow which related with kill_rule(), I can
not find any of them can lead audit_add_tree_rule() to cause issue: all
work flow related with kill_rule() are protected by audit_cmd_mutex now.


Test plan:
  code preparation:
    define a flag varaible.
    wait the flag to be true, before lock 'audit_filter_mutex' again. in audit_add_tree_rule()
    when evict_trunc() finish, set the flag true.
  firstly start: 'rm -rvf /tmp/gchen/linux-next'
  then start: 'audit -w /tmp/gchen/linux-next/drivers/char'
    (notice the order should not be changed, or all system call will be locked)

Test result:
  the evict_chunk() will not call kill_rule() directly, so no issues.
  the output sample result like this: ('printk' the related information)

---------------------------sample begin-----------------------------

[   85.455891] gchen_tag: ffff880099f0ddc0, audit_init_entry(): create entry: ffff880097ca2800
[   85.455900] gchen_tag: ffff880099f0ddc0, audit_receive_filter(): before call, type: 1011
[   85.455903] gchen_tag: ffff880099f0ddc0, audit_add_tree_rule(): enter function
[   85.455927] ida_remove called for id=0 which is not allocated.
[   85.455935] gchen_tag: ffff880099f0ddc0, audit_add_tree_rule(): begin waiting 100...., rule: ffff880097ca2820
[   91.425947] gchen_tag: ffff880097995dc0, fsnotify_clear_marks_by_inode(): set audit_test_count = true
[   91.425960] gchen_tag: ffff880099f0ddc0, audit_add_tree_rule(): end waiting, rule: ffff880097ca2820
[   91.426055] gchen_tag: ffff880099f0ddc0, audit_receive_filter(): after call for succeed, type: 1011
[   91.426558] gchen_tag: ffff880097995dc0, kill_rules(): list_del_init, rule: ffff880097ca2820, tree: ffff880099dfff00
[   91.426564] gchen_tag: ffff880097995dc0, kill_rules(): remove entry: ffff880097ca2800
[   91.431023] gchen_tag: ffff880097995dc0, audit_free_rule(): remove entry: ffff880097ca2800

---------------------------sample end-------------------------------


Now, my original fix makes the related code consistent, but the related
code maybe be useless now (if what I said is true, in audit, quite a
few of code are useless for this reason).

I can not be sure whether these useless code will be used, in the
future (whether let AUDIT_TREE and AUDIT_WATCH independent on
AUDIT_SYSCALL in the future).

If it will be used in the future, my fix is useful too, else we'd
better to delete the related useless code.

Thanks.

> I think, it will cause issue (randomly): if when we are using auditctl
> to add rule to monitor one file, and at the same time, the other user is
> just deleting this file.
> 
> I guess, it is why original code need 'if (list_empty(&rule->rlist))'
> after lock 'audit_filter_mutex' again.
> 
> Currently, I am just testing for it (and should give a test), and I will
> send the test plan and test result within this week (2013-05-12).
> 
> 
> Thanks.
> 
> -- Chen Gang Asianux Corporation
> 


-- 
Chen Gang

Asianux Corporation
