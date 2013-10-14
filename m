Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3JNJRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:17:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63031 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3JNJRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:17:45 -0400
Message-ID: <525BB6E0.9030600@gmail.com>
Date: Mon, 14 Oct 2013 20:18:24 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: George Spelvin <linux@horizon.com>, joe@perches.com,
        akpm@linux-foundation.org, dan.j.rosenberg@gmail.com,
        eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com,
        jkosina@suse.cz, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
References: <20131011044232.11545.qmail@science.horizon.com>	<525875DB.9030300@gmail.com> <87d2nba0yb.fsf@xmission.com>
In-Reply-To: <87d2nba0yb.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 09:37, Eric W. Biederman wrote:

> Ryan Mallon <rmallon@gmail.com> writes:
> 
>> The only remaining problem is kernel/module.c:module_sect_show() which
>> is used to write the sysfs files in /sys/module/<modname>/sections/.
>> Those files are actually are really good target for leaking %pK values
>> via setuid binaries. The problem is that the module_sect_show() function
>> isn't passed information about who opened the sysfs file. I don't think
>> this information is available in general for sysfs files either. Also,
>> I can't actually see how module_sect_show() gets called?
>>
>> I'm a bit stuck on how to solve this. Any ideas?
> 
> I haven't yet had a chance to review the patches but there are patches
> to make sysfs files seq files in Greg's driver core tree.


Hmm, I had a look at the driver-core tree, and although sysfs files
internally use the seq_file interface, the sysfs show/store handlers do
not get passed the struct seq_file, so doesn't appear possible to do the
checks there.

We could add a sysfs_ops->seq_show, but that feels clunky to have two
different interfaces for handling sysfs files. Converting the whole
tree to pass struct seq_file to the sysfs handlers would be painful :-/.

I assume the reason the /sys/module/<modname>/sections/* cannot be made
0400 is that some user-space tools are expecting those files to be
readable by unprivileged users?

~Ryan
