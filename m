Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3JKWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:03:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50056 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3JKWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:03:34 -0400
Message-ID: <525875DB.9030300@gmail.com>
Date: Sat, 12 Oct 2013 09:04:11 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: ebiederm@xmission.com, joe@perches.com, akpm@linux-foundation.org,
        dan.j.rosenberg@gmail.com, eldad@fogrefinery.com,
        jgunthorpe@obsidianresearch.com, jkosina@suse.cz,
        keescook@chromium.org, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        rusty@rustcorp.com.au
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
References: <20131011044232.11545.qmail@science.horizon.com>
In-Reply-To: <20131011044232.11545.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/13 15:42, George Spelvin wrote:

> ebiederm@xmission.com (Eric W. Biederman) wrote:
>> Sigh.  This is all wrong.  The only correct thing to test is
>> file->f_cred.  Aka the capabilities of the program that opened the
>> file.
>>
>> Which means that the interface to %pK in the case of kptr_restrict is
>> broken as it has no way to be passed the information it needs to make
>> a sensible decision.
> 
> I looked at the code, and pretty painful.  Certainly it's possible to
> include a reference to the file (I was thinking of just the credentials,
> actually) in the seq_file.  But getting that to the vsprintf.c code
> (specifically, the pointer() function) is a PITA.
> 
> I'm willing to accept the currently proposed kludge as a "good enough"
> approximation, as long as we're all agreed that using the credentials
> at open() time would be The Right Thing, and hopefully someone will find
> the round tuitts to implement that in future.
> 
> But in the meantime, "the perfect is the enemey of the good" is worth
> remembering.
> 
> (An alternate implementation I've been thinking about would be to do
> away with %pK, and instead have a "secret_ptr(p, seq->cred)" helper that
> returned p or 0 depending on the credential.)


I've been looking at this approach. The majority of %pK uses are in
seq_files, so George's suggestion will work fine there. 

There are a handful of instances in printk() statements. I don't think
%pK can ever make sense from printk(), because it is basically impossible
to do any sane permission check. If a setuid binary does some action
with elevated which causes printk() to be called then the user might see
leaked kernel pointers. The correct way to prevent this is to use
dmesg_restrict and not allow normal users to see the syslog.

The only remaining problem is kernel/module.c:module_sect_show() which
is used to write the sysfs files in /sys/module/<modname>/sections/.
Those files are actually are really good target for leaking %pK values
via setuid binaries. The problem is that the module_sect_show() function
isn't passed information about who opened the sysfs file. I don't think
this information is available in general for sysfs files either. Also,
I can't actually see how module_sect_show() gets called?

I'm a bit stuck on how to solve this. Any ideas?

~Ryan


