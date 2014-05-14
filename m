Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaENRP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:15:59 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63686 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbaENRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140512145027.e60426e59d99961236344827@linux-foundation.org>
References: <20140512072027.e715c362ff587e46ea83fb0c@skynet.be>
	<20140512145027.e60426e59d99961236344827@linux-foundation.org>
Date: Wed, 14 May 2014 13:15:36 -0400
Message-ID: <CAATkVEypeMQmcmDoboeLE8Q3R7jcr4KsHe0b-f7RvQDAvzxfjg@mail.gmail.com>
Subject: Re: [PATCH V5 1/2] FS: Add generic data flush to fsync
From: Debabrata Banerjee <dbavatar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        hch <hch@infradead.org>, Viro <viro@zeniv.linux.org.uk>,
        tytso <tytso@mit.edu>, "Banerjee, Debabrata" <dbanerje@akamai.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 5:50 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 12 May 2014 07:20:27 +0200 Fabian Frederick <fabf@skynet.be> wrote:
>
>> This patch issues a flush in generic_file_fsync.
>> (Modern filesystems already do it)
>>
>> Behaviour can be reversed using /sys/devices/.../cache_type
>> or by calling __generic_file_fsync
>
> Well OK, but why?  What effect does the patch have?  Does it make the
> kernel better and if so, how?

Doing flush of the device cache is the right to do. Without this, any
fsync or sync call makes absolutely no guarantees that your data is on
non-volatile storage, and both calls or commands may as well be a NOP,
especially given the sizes of write-back caches on modern drives.

This actually fixes a long standing problem with ext4, that
sync()/fsync() actually don't function if you don't have journal
enabled. However a patch to ext4 may be considered such that nobarrier
mount flag is honored without a journal via calling
__generic_file_fsync instead.

i.e.

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index a8bc47f..779018a 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -107,7 +107,11 @@ int ext4_sync_file(struct file *file, loff_t
start, loff_t end, int datasync)
        }

        if (!journal) {
-               ret = generic_file_fsync(file, start, end, datasync);
+               if (test_opt(inode->i_sb, BARRIER))
+                       ret = generic_file_fsync(file, start, end, datasync);
+               else
+                       ret = __generic_file_fsync(file, start, end, datasync);
+
                if (!ret && !hlist_empty(&inode->i_dentry))
                        ret = ext4_sync_parent(inode);
                goto out;
diff --git a/Documentation/filesystems/ext4.txt
b/Documentation/filesystems/ext4.txt
index 919a329..3781568 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -182,8 +182,8 @@ commit=nrsec        (*)     Ext4 can be told to
sync all its data and metadata
                        Setting it to very large values will improve
                        performance.

-barrier=<0|1(*)>       This enables/disables the use of write barriers in
-barrier(*)             the jbd code.  barrier=0 disables, barrier=1 enables.
+barrier=<0|1(*)>       This enables/disables the use of write barriers.
+barrier(*)             barrier=0 disables, barrier=1 enables.
 nobarrier              This also requires an IO stack which can support
                        barriers, and if jbd gets an error on a barrier
                        write, it will disable again with a warning.
