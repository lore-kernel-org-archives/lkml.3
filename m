Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaH1Ocq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:32:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50663 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaH1Ocp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:32:45 -0400
Date: Thu, 28 Aug 2014 15:32:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: rtg.canonical@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH v2] fs: namespace: suppress 'may be used uninitialized'
 warnings
Message-ID: <20140828143243.GH18016@ZenIV.linux.org.uk>
References: <20140827210112.GE18016@ZenIV.linux.org.uk>
 <1409234149-3485-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409234149-3485-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 07:55:49AM -0600, rtg.canonical@gmail.com wrote:
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> The gcc version 4.9.1 compiler complains even though it isn't possible for
> these variables to not get initialized before they are used.

Sigh...  The root cause of that shite is that copy_mount_string() is too
convoluted for gcc (piss-poor) detection of uninitialized variables.  And
yes, it is somewhat overcomplicated - it returns 0 or -E... *and* in former
case it returns NULL or a string as well, via a char ** argument.

The usual convention for such suckers is "return a pointer, using
ERR_PTR(-E...) to indicate an error".  We have all of 4 (four) callers,
all in fs/*.c (and nobody else could see that function, unless they manually
included fs/internal.h).

So let's turn that into
char *copy_mount_string(const void __user *data)
{
	return data ? strndup_user(data, PAGE_SIZE) : NULL;
}

and uses of that thing into
        kernel_type = copy_mount_string(type);
	ret = PTR_ERR(kernel_type);
        if (IS_ERR(kernel_type))
                goto out_type;
etc.
