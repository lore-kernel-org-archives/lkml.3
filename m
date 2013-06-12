Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3FLTD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:03:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab3FLTDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:03:24 -0400
Message-ID: <51B8C639.7060500@redhat.com>
Date: Wed, 12 Jun 2013 12:04:25 -0700
From: Anand Avati <avati@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxim Patlasov <MPatlasov@parallels.com>
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] fuse: hold i_mutex in fuse_file_fallocate()
References: <20130611105714.24455.38409.stgit@maximpc.sw.ru>
In-Reply-To: <20130611105714.24455.38409.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/13 3:59 AM, Maxim Patlasov wrote:

> -	if (mode & FALLOC_FL_PUNCH_HOLE) {
> +	if (lock_inode)
>   		mutex_lock(&inode->i_mutex);

> +	if (mode & FALLOC_FL_PUNCH_HOLE)
>   		fuse_set_nowrite(inode);
> -	}

Just for clarity, can you make the condition to check 
FALLOC_FL_PUNCH_HOLE and call to fuse_set_nowrite() nested within the 
larger if (lock_inode) { .. } block? fuse_set_nowrite() should not be 
called without i_mutex acquired. The current style of calling 
mutex_lock() and fuse_set_nowrite() in separate conditions can 
potentially cause bugs in the future if they were to get re-ordered due 
to some unrelated patch. Nesting them makes the relation more explicit 
and clear.

Thanks,
Avati

