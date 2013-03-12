Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab3CLXBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:01:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741Ab3CLXBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:01:37 -0400
Date: Tue, 12 Mar 2013 16:01:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: Re: [PATCH v5 1/2] mm: limit growth of 3% hardcoded other user
 reserve
Message-Id: <20130312160136.b0f09ca7b1b4f2efe01f6617@linux-foundation.org>
In-Reply-To: <20130306235201.GA1421@localhost.localdomain>
References: <20130306235201.GA1421@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013 18:52:01 -0500 Andrew Shewmaker <agshew@gmail.com> wrote:

> Add user_reserve_pages knob.
> 
> Limit the growth of the memory reserved for other user
> processes to min(3% current process, user_reserve_pages).
> 
> user_reserve_pages defaults to min(3% free pages, 128MB)
> I arrived at 128MB by taking that max VSZ of sshd, login, 
> bash, and top ... then adding the RSS of each.
> 
> This only affects OVERCOMMIT_NEVER mode.

Can we have a more complete changelog, please?  One which describes, at
great length, *why* we're doing this.  Describe the problems you
observed, the possible means of addressing them, why this means is
considered best, etc.

Also, there has been considerable discussion over this patchset and it
is good to update the changelogs to reflect that discussion.  Partly
because other people will be asking the same questions when they see
the patches and partly so that reviewers can understand how earlier
objections/suggestions were addressed.  Assume that your audience
has not read this email thread!

>From a quick read of the code, it appears that the root-cant-log-in
problem was addressed by simply leaving it up to the administrator,
yes?  If the administrator sets user_reserve_pages or
admin_reserve_pages to zero then they risk hitting the root-cant-log-in
problem, yes?  If so then I guess this is an OK approach, but we should
clearly describe the risks in the documentation.

Finally, I am allergic to exported interfaces which deal in "pages". 
Because PAGE_SIZE can vary by a factor of 16 depending upon config (ie:
architecture).  The risk is that a setup script which works nicely on
4k x86_64 will waste memory when executed on a 64k PAGE_SIZE powerpc
box.  A smart programmer will recognize this and will adapt the setting
using getpagesize(2), but if we define these things in "bytes" rather
than "pages" then dumb programmers can use it too.

