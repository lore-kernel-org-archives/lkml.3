Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaCCVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:04:04 -0500
Received: from science.horizon.com ([71.41.210.146]:53462 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753010AbaCCVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:04:02 -0500
Date: 3 Mar 2014 16:03:59 -0500
Message-ID: <20140303210359.26624.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: torvalds@linux-foundation.org
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Cc: linux@horizon.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  struct fd {
>  	struct file *file;
> -	int need_put;
> +	unsigned need_put:1, need_pos_unlock:1;
>  };

Since we're rounding up to 2*sizeof(struct file *) anyway, is this a case
where wasting space on a couple of char (or bool) flags would generate
better code than a bitfield?

In particular, the code to set need_pos_unlock (which will be executed
each read/write for most files) is messy in the bitfield case.
A byte store is much cleaner.

(If you want to use bits, why not use the two lsbits of the file pointer
for the purpose?  That would save a lot of space.)
