Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3AaGTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 01:19:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:38252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab3AaGTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 01:19:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,574,1355126400"; 
   d="scan'208";a="278914192"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tang, Guifang" <guifang.tang@intel.com>,
        "Chen, LinX Z" <linx.z.chen@intel.com>,
        Arve Hj?nnev?g <arve@android.com>
Subject: RE: Avoid high order memory allocating with kmalloc, when read
 large seq file
Thread-Topic: Avoid high order memory allocating with kmalloc, when read
 large seq file
Thread-Index: Ac3959WFzzKYFRNtRmipg8hWsw6AugAVUhGAAE9ISXA=
Date: Thu, 31 Jan 2013 06:19:15 +0000
Message-ID: <EE928378561BF1449699C96571234A740FF804C8@SHSMSX102.ccr.corp.intel.com>
References: <510768B6.3070000@intel.com>
 <20130129162431.58754538.akpm@linux-foundation.org>
In-Reply-To: <20130129162431.58754538.akpm@linux-foundation.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morton
  Thank you very much for your kindly info, In android system,, when you read /sys/kernel/debug/binder/proc/xxx, xxx is the process id , it will trigger high order kmalloc.
But we can't limit the size of binder info, because we need this to debug the binder related issue.
I had re-send the patch, how do you think for about using vmalloc instaed of kmalloc when malloc high order allocating? Memory gragment should not be the issue, because this is very quick to free such memory.

Br
Xiaobing


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Wednesday, January 30, 2013 8:25 AM
To: Tu, Xiaobing
Cc: linux-kernel@vger.kernel.org; Tang, Guifang; Chen, LinX Z; Arve Hjønnevåg
Subject: Re: Avoid high order memory allocating with kmalloc, when read large seq file

On Tue, 29 Jan 2013 14:14:14 +0800
xtu4 <xiaobing.tu@intel.com> wrote:

> @@ -209,8 +209,17 @@ ssize_t seq_read(struct file *file, char __user 
> *buf, size_t size, loff_t *ppos)
>           if (m->count < m->size)
>               goto Fill;
>           m->op->stop(m, p);
> -        kfree(m->buf);
> -        m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
> +        if (m->size > 2 * PAGE_SIZE) {
> +            vfree(m->buf);
> +        } else
> +            kfree(m->buf);
> +        m->size <<= 1;
> +        if (m->size > 2 * PAGE_SIZE) {
> +            m->buf = vmalloc(m->size);
> +        } else
> +            m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
> +
> +
>           if (!m->buf)
>               goto Enomem;
>           m->count = 0;
> @@ -325,7 +334,10 @@ EXPORT_SYMBOL(seq_lseek);

The conventional way of doing this is to attempt the kmalloc with __GFP_NOWARN and if that failed, fall back to vmalloc().

Using vmalloc is generally not a good thing, mainly because of fragmentation issues, but for short-lived allocations like this, that shouldn't be too bad.

But really, the binder code is being obnoxious here and it would be best to fix it up.  Please identify with some care which part of the binder code is causing this problem.  binder_stats_show(), from a guess?  It looks like that function's output size is proportional to the number of processes on binder_procs?  If so, there is no upper bound, is there?  Problem!

btw, binder_debug_no_lock should just go away.  That list needs locking.
