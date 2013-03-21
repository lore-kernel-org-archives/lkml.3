Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3CUX6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:58:43 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:46105 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3CUX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130321233630.GE21522@ZenIV.linux.org.uk>
References: <20130321192935.GY21522@ZenIV.linux.org.uk>
	<CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
	<20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 16:58:41 -0700
X-Google-Sender-Auth: 2MxxpDXCfP0XT0BC-nrsbYYhOjs
Message-ID: <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 4:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Some netns-related idiocy.  Oh, shit...
>
> al@duke:~/linux/trees/vfs$ ls -lid /proc/{1,2}/net/stat
> 4026531842 dr-xr-xr-x 2 root root 0 Mar 21 19:33 /proc/1/net/stat
> 4026531842 dr-xr-xr-x 2 root root 0 Mar 21 19:33 /proc/2/net/stat
>
> Eric, would you mind explaining WTF is going on here?  Again, WE CAN NOT
> HAVE SEVERAL DENTRIES OVER THE SAME DIRECTORY INODE.  Ever.  We do that,
> we are fucked.

Hmm. That certainly explains the situation, but it leaves me wondering
whether the simplest solution to this is not to say "ok, let's allow
it in this case".

The locking is already per-inode, so we can literally change the code
that checks "if same dentry" to "if same inode" instead.

And the only other reason we don't want to allow it is to make sure
you can't have directory loops etc, afaik, and again, for this
particular case of /proc, we happen to be ok.

So yes, it's against the rules, and we get that deadlock right now,
but one solution would be to just allow this particular case. The
patch for the deadlock looks dead simple:

    diff --git a/fs/namei.c b/fs/namei.c
    index 57ae9c8c66bf..435002f99bd8 100644
    --- a/fs/namei.c
    +++ b/fs/namei.c
    @@ -2277,7 +2277,7 @@ struct dentry *lock_rename(struct dentry
*p1, struct dentry *p2)
     {
             struct dentry *p;

    -        if (p1 == p2) {
    +        if (p1->d_inode == p2->d_inode) {
                     mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
                     return NULL;
             }
    @@ -2306,7 +2306,7 @@ struct dentry *lock_rename(struct dentry
*p1, struct dentry *p2)
     void unlock_rename(struct dentry *p1, struct dentry *p2)
     {
             mutex_unlock(&p1->d_inode->i_mutex);
    -        if (p1 != p2) {
    +        if (p1->d_inode != p2->d_inode) {
                     mutex_unlock(&p2->d_inode->i_mutex);
                     mutex_unlock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
             }

Are there any other reasons why these kinds of "hardlinked
directories" would cause problems?

             Linus
