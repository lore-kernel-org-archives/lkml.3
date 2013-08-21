Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3HUU6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:58:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3HUU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:58:23 -0400
Date: Wed, 21 Aug 2013 13:58:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, fs: avoid page allocation beyond i_size on read
Message-Id: <20130821135821.fc8f5a2551a28c9ce9c4b049@linux-foundation.org>
In-Reply-To: <1377103332.2738.37.camel@menhir>
References: <1377099441-2224-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1377100012.2738.28.camel@menhir>
	<20130821160817.940D3E0090@blue.fi.intel.com>
	<1377103332.2738.37.camel@menhir>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 17:42:12 +0100 Steven Whitehouse <swhiteho@redhat.com> wrote:

> > I don't think the change is harmful. The worst case scenario is race with
> > write or truncate, but it's valid to return EOF in this case.
> > 
> > What scenario do you have in mind?
> > 
> 
> 1. File open on node A
> 2. Someone updates it on node B by extending the file
> 3. Someone reads the file on node A beyond end of original file size,
> but within end of new file size as updated by node B. Without the patch
> this works, with it, it will fail. The reason being the i_size would not
> be up to date until after readpage(s) has been called.
> 
> I think this is likely to be an issue for any distributed fs using
> do_generic_file_read(), although it would certainly affect GFS2, since
> the locking is done at page cache level,

Boy, that's rather subtle.  I'm surprised that the generic filemap.c
stuff works at all in that sort of scenario.

Can we put the i_size check down in the no_cached_page block?  afaict
that will solve the problem without breaking GFS2 and is more
efficient?

