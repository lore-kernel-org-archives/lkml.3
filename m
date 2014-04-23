Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaDWV6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:58:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52769 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDWV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:58:05 -0400
Date: Wed, 23 Apr 2014 22:58:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengwei Yin <yfw.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix seq_read dead loop and trigger memory allocation
 failure.
Message-ID: <20140423215804.GU18016@ZenIV.linux.org.uk>
References: <1398089562-5925-1-git-send-email-yfw.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398089562-5925-1-git-send-email-yfw.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 10:12:42PM +0800, Fengwei Yin wrote:
> When dump /proc/xxx/maps, if d_path return error in seq_path, the
> buffer will be exhaust and trigger dead loop in seq_read. Till
> kmalloc fails with -ENOMEM.

*WHAT* d_path error?  -ENAMETOOLONG, aka. "you've got too little space"?

> @@ -295,8 +295,16 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
>  	 * special [heap] marker for the heap:
>  	 */
>  	if (file) {
> +		size_t sz;
>  		seq_pad(m, ' ');
> -		seq_path(m, &file->f_path, "\n");
> +		/* Save current count. Once seq_path return negtive value,
> +		 * we need to restore saved count. Otherwise, seq_path will
> +		 * exhaust the buffer and make seq_read dead loop till
> +		 * m->buff allocation failure.
> +		 */
> +		sz = m->count;
> +		if (seq_path(m, &file->f_path, "\n") < 0)
> +			m->count = sz;

NAK.  No way in hell.  Any code playing with m->count that way is broken.
Post the reproducer for that infinite loop; then we'll be able to see
what triggers an impossible error from d_path().  _That_ is where the bug
is, assuming it exists at all.
