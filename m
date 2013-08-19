Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3HSLaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:30:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63464 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3HSLaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:30:14 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <CAKZGPANS-NVTy7p69xcrgK3ggUHAtLi2ad8UgwsYdeEHbj3gMw@mail.gmail.com>
References: <CAKZGPANS-NVTy7p69xcrgK3ggUHAtLi2ad8UgwsYdeEHbj3gMw@mail.gmail.com>
Date: Mon, 19 Aug 2013 17:00:14 +0530
X-Google-Sender-Auth: io1fcelzRXWZlqIODZIfmLcnpeA
Message-ID: <CAKZGPAPdqgJJnrWo-nzwm2CiCA4405iuB-Tco25j4JDB6qQPRg@mail.gmail.com>
Subject: Re: [PATCH] SeqFile: Fix overflow condition
From: Arun KS <arunks.linux@gmail.com>
To: viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Bruce Fields <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch.

I ll send an updated one.

Thanks,
Arun

On Mon, Aug 19, 2013 at 12:25 PM, Arun KS <arunks.linux@gmail.com> wrote:
> From 23986a85b9efe7bc3ffc0887b8d17cdf2fbab4f2 Mon Sep 17 00:00:00 2001
> From: Arun KS <arun.ks@broadcom.com>
> Date: Mon, 19 Aug 2013 12:06:33 +0530
> Subject: SeqFile: Fix overflow condition
>
> seq_path()/seq_commit() is treating a d_path() failure as an overflow
> condition, but it isn't.
>
> Signed-off-by: Arun KS <arun.ks@broadcom.com>
> ---
>  fs/seq_file.c            |  6 +++---
>  include/linux/seq_file.h | 11 ++++++-----
>  2 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3135c25..6a33f9c 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -463,7 +463,7 @@ int seq_path(struct seq_file *m, const struct path
> *path, const char *esc)
>  {
>   char *buf;
>   size_t size = seq_get_buf(m, &buf);
> - int res = -1;
> + int res = -ENOBUFS;
>
>   if (size) {
>   char *p = d_path(path, buf, size);
> @@ -487,7 +487,7 @@ int seq_path_root(struct seq_file *m, const struct
> path *path,
>  {
>   char *buf;
>   size_t size = seq_get_buf(m, &buf);
> - int res = -ENAMETOOLONG;
> + int res = -ENOBUFS;
>
>   if (size) {
>   char *p;
> @@ -516,7 +516,7 @@ int seq_dentry(struct seq_file *m, struct dentry
> *dentry, const char *esc)
>  {
>   char *buf;
>   size_t size = seq_get_buf(m, &buf);
> - int res = -1;
> + int res = -ENOBUFS;
>
>   if (size) {
>   char *p = dentry_path(dentry, buf, size);
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 4e32edc..7bfb540 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -66,16 +66,17 @@ static inline size_t seq_get_buf(struct seq_file
> *m, char **bufp)
>   * @num: the number of bytes to commit
>   *
>   * Commit @num bytes of data written to a buffer previously acquired
> - * by seq_buf_get.  To signal an error condition, or that the data
> - * didn't fit in the available space, pass a negative @num value.
> + * by seq_buf_get.  To signal an overflow condition(data didn't fit
> + * in the available space), pass -ENOBUFS and for other errors pass a
> + * negative @num value.
>   */
>  static inline void seq_commit(struct seq_file *m, int num)
>  {
> - if (num < 0) {
> - m->count = m->size;
> - } else {
> + if (num >= 0) {
>   BUG_ON(m->count + num > m->size);
>   m->count += num;
> + } else if (num == -ENOBUFS)
> + m->count = m->size;
>   }
>  }
>
> --
> 1.8.2
