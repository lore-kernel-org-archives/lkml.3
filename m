Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3JVKfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:35:13 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53506 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3JVKfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG-pUTfWiVznsKkQH0bBiHgbi+waHNw0zmoTMVk4pVJGPUN_A@mail.gmail.com>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	<1381185204.2081.221.camel@joe-AO722>
	<CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
	<1381191145.2081.230.camel@joe-AO722>
	<CAGG-pUQJCGcY=hAobBodH-dTLLohUpe6KJbuMvwWkhdt3RSk+A@mail.gmail.com>
	<CAFkjPTmFOkw5n964zGuiON1oLSy1CsPQQ8TrGNho6L-+M5Z7SA@mail.gmail.com>
	<CAGG-pUTHAnPOiX0n6FjbkhtFeiOY-704_rEvrhkzo4uv1rQ=hA@mail.gmail.com>
	<CAGG-pUTfWiVznsKkQH0bBiHgbi+waHNw0zmoTMVk4pVJGPUN_A@mail.gmail.com>
Date: Tue, 22 Oct 2013 08:35:09 -0200
Message-ID: <CAGG-pUQyB_4ivOvJWvq_5p-o-5vOC6srNVRk0GAvqqG-PVGMrQ@mail.gmail.com>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Joe Perches <joe@perches.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/21 Geyslan Gregório Bem <geyslan@gmail.com>:
> 2013/10/21 Geyslan Gregório Bem <geyslan@gmail.com>:
>> 2013/10/20 Eric Van Hensbergen <ericvh@gmail.com>:
>>> Please resubmit a clean patch which includes the check of sscanf for exactly
>>> the correct number of arguments and handles errors properly in other cases.
>>> That last bit may be a bit problematic since right now the only errors are
>>> prints and we seem to be otherwise silently failing.  Of course, looks like
>>> nothing else is checking return values from that function for error.  We
>>> could set rdev to an ERR_PTR(-EIO), and then go through and do a check in
>>> all the places which matter (looks like there are a few places where rdev
>>> just gets discarded -- might even be a good idea to not parse rdev unless we
>>> need to by passing NULL to p9mode2unixmode.
>>>
>>> All in all, its a corner case which is only likely with a broken server, but
>>> the full clean up would seem to be:
>>>   a) switch to u32's
>>>   b) pass NULL when rdev just gets discarded and don't bother parsing when
>>> it is
>>>   c) check the sscanf return validity
>>>   d) on error set ERR_PTR in rdev and check on return before proceeding
>>>
>>> That's a lot of cleanup, I'll add it to my work queue if you don't have time
>>> to rework your patch.
>>>
>>
>> Eric, I would like to try with your guidance.
>>
>>> For the other patches, anyone you didn't see a response from me on today is
>>> being pulled into my for-next queue.  Thanks for the cleanups.
>>>
>>>       -eric
>>
>> Thanks for accept them.
>>
>>>
>>>
>>>
>>>
>>> On Mon, Oct 7, 2013 at 7:18 PM, Geyslan Gregório Bem <geyslan@gmail.com>
>>> wrote:
>>>>
>>>> Joe,
>>>>
>>>> Nice, I'll wait their reply, there are other p9 patches that I have
>>>> already sent and am awaiting Eric's.
>>>>
>>>> Thank you again.
>>>>
>>>> Geyslan Gregório Bem
>>>> hackingbits.com
>>>>
>
> Let me know if I got your requests:
>
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 94de6d1..8a332d0 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -63,7 +63,7 @@ static const struct inode_operations
> v9fs_symlink_inode_operations;
>
>  static u32 unixmode2p9mode(struct v9fs_session_info *v9ses, umode_t mode)
>  {
> -    int res;
> +    u32 res;
>      res = mode & 0777;
>      if (S_ISDIR(mode))
>          res |= P9_DMDIR;
> @@ -125,7 +125,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
>  static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
>                     struct p9_wstat *stat, dev_t *rdev)
>  {
> -    int res;
> +    umode_t res;
>      u32 mode = stat->mode;
>
>      *rdev = 0;
> @@ -144,10 +144,15 @@ static umode_t p9mode2unixmode(struct
> v9fs_session_info *v9ses,
>      else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
>           && (v9ses->nodev == 0)) {
>          char type = 0, ext[32];
> -        int major = -1, minor = -1;
> +        u32 major = 0, minor = 0;
>
>          strlcpy(ext, stat->extension, sizeof(ext));
> -        sscanf(ext, "%c %u %u", &type, &major, &minor);
> +        if (sscanf(ext, "%c %u %u", &type, &major, &minor) < 3) {
> +            p9_debug(P9_DEBUG_ERROR,
> +                 "It's necessary define type [%u], major [u%] and minor [u%]" \
> +                 "values when using P9_DMDEVICE", type, major, minor);
> +            goto err_dev;
> +        }
>          switch (type) {
>          case 'c':
>              res |= S_IFCHR;
> @@ -158,11 +163,16 @@ static umode_t p9mode2unixmode(struct
> v9fs_session_info *v9ses,
>          default:
>              p9_debug(P9_DEBUG_ERROR, "Unknown special type %c %s\n",
>                   type, stat->extension);
> +            goto err_dev;
>          };
>          *rdev = MKDEV(major, minor);
>      } else
>          res |= S_IFREG;
> +    goto ret;
>
> +err_dev:
> +    rdev = ERR_PTR(-EIO);
> +ret:
>      return res;
>  }
>
> @@ -460,13 +470,17 @@ void v9fs_evict_inode(struct inode *inode)
>
>  static int v9fs_test_inode(struct inode *inode, void *data)
>  {
> -    int umode;
> +    umode_t umode;
>      dev_t rdev;
>      struct v9fs_inode *v9inode = V9FS_I(inode);
>      struct p9_wstat *st = (struct p9_wstat *)data;
>      struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
>
>      umode = p9mode2unixmode(v9ses, st, &rdev);
> +
> +    if (IS_ERR(rdev))
> +        return 0;
> +
>      /* don't match inode of different type */
>      if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
>          return 0;
> @@ -526,6 +540,11 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
>       */
>      inode->i_ino = i_ino;
>      umode = p9mode2unixmode(v9ses, st, &rdev);
> +    if (IS_ERR(rdev)) {
> +        retval = rdev;
> +        goto error;
> +    }
> +
>      retval = v9fs_init_inode(v9ses, inode, umode, rdev);
>      if (retval)
>          goto error;
> @@ -1461,9 +1480,10 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry
> *dentry, umode_t mode, dev_t rde
>
>  int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
>  {
> -    int umode;
> +    umode_t umode;
>      dev_t rdev;
>      loff_t i_size;
> +    int ret = 0;
>      struct p9_wstat *st;
>      struct v9fs_session_info *v9ses;
>
> @@ -1475,6 +1495,11 @@ int v9fs_refresh_inode(struct p9_fid *fid,
> struct inode *inode)
>       * Don't update inode if the file type is different
>       */
>      umode = p9mode2unixmode(v9ses, st, &rdev);
> +    if (IS_ERR(rdev)) {
> +        ret = rdev;
> +        goto out;
> +    }
> +
>      if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
>          goto out;
>
> @@ -1491,7 +1516,7 @@ int v9fs_refresh_inode(struct p9_fid *fid,
> struct inode *inode)
>  out:
>      p9stat_free(st);
>      kfree(st);
> -    return 0;
> +    return ret;
>  }
>
>  static const struct inode_operations v9fs_dir_inode_operations_dotu = {
>

I didn't compile it. It's just a sketch.

The rdev tests (in the callers) must be:
if (rdev < 0) {
...

Waiting your reply.

Cheers.
>
>>>>
>>>> 2013/10/7 Joe Perches <joe@perches.com>:
>>>> > On Mon, 2013-10-07 at 21:09 -0300, Geyslan Gregório Bem wrote:
>>>> >> Joe,
>>>> >>
>>>> >> Thank you for reply.
>>>> >>
>>>> >> What do you think about:
>>>> >>
>>>> >>                  strncpy(ext, stat->extension, sizeof(ext));
>>>> >> +                 if (sscanf(ext, "%c %u %u", &type, &major, &minor) <
>>>> >> 3) {
>>>> >> +                                  p9_debug(P9_DEBUG_ERROR,
>>>> >> +                                  "It's necessary define type, major
>>>> >> and minor values when using P9_DMDEVICE");
>>>> >> +                                  return res;
>>>> >> +                 }
>>>> >>                  switch (type) {
>>>> >>                  case 'c':
>>>> >>                          res |= S_IFCHR;
>>>> >>                          break;
>>>> >> ...
>>>> >>                  *rdev = MKDEV(major, minor);
>>>> >
>>>> > I think the plan 9 folk should figure out what's right.
>>>> >
>>>> >
>>>
>>>
