Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaJOXJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:09:18 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:41878 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaJOXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141015152013.GB988@ubuntu-mba51>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
 <1413296756-25071-6-git-send-email-seth.forshee@canonical.com>
 <543E8BAD.7000207@mit.edu> <20141015152013.GB988@ubuntu-mba51>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Oct 2014 16:08:54 -0700
Message-ID: <CALCETrW4DQwsjtzF1_HRka+=ifX3e+7b3jkE9T=6mXC-_vSO5w@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] fuse: Allow user namespace mounts
To: Andy Lutomirski <luto@amacapital.net>, Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 8:20 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Oct 15, 2014 at 07:58:53AM -0700, Andy Lutomirski wrote:
>> On 10/14/2014 07:25 AM, Seth Forshee wrote:
>> > Cc: Eric W. Biederman <ebiederm@xmission.com>
>> > Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
>> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> > ---
>> >  fs/fuse/inode.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> > index 5e00a6a76049..6522926b14e4 100644
>> > --- a/fs/fuse/inode.c
>> > +++ b/fs/fuse/inode.c
>> > @@ -1212,7 +1212,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
>> >  static struct file_system_type fuse_fs_type = {
>> >     .owner          = THIS_MODULE,
>> >     .name           = "fuse",
>> > -   .fs_flags       = FS_HAS_SUBTYPE,
>> > +   .fs_flags       = FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
>> >     .mount          = fuse_mount,
>> >     .kill_sb        = fuse_kill_sb_anon,
>> >  };
>> > @@ -1244,7 +1244,7 @@ static struct file_system_type fuseblk_fs_type = {
>> >     .name           = "fuseblk",
>> >     .mount          = fuse_mount_blk,
>> >     .kill_sb        = fuse_kill_sb_blk,
>> > -   .fs_flags       = FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
>> > +   .fs_flags       = FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
>>
>> I think it's decision time -- if these patches are applied, then FUSE
>> will be the first filesystem for which userns nodev behavior matters for
>> security, so applying this patch will enshrine an API decision.
>>
>> I would very much prefer to make this patch depend on this:
>>
>> http://lkml.kernel.org/g/2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net
>>
>> That change will require that anyone who tries to mount one of these
>> things explicitly requests MS_NODEV instead of keeping the current
>> behavior of implicitly setting MS_NODEV and possibly confusing user code
>> that tries to remount.
>>
>> If you like my patch, feel free to fold it in to your series, or Eric
>> can apply it directly (pretty please).
>>
>> For background, with your patches as is, if you mount a FUSE fs and then
>> remount it with identical flags, the remount is likely to fail.
>
> I discussed this with Eric during LinuxCon NA ... as I recall he was
> undecided about whether or not to use your patch at the time. I do
> prefer an explicit failure over implicitly adding MS_NODEV, but it's not
> up to me. I do agree though that we should make a decision before
> merging the fuse patches, I was just assuming that the decision was
> already made.

As far as I know, no decision has been made.  I discussed it with Eric
at LinuxCon NA, too.  Too bad we didn't meet there.

Hopefully your patches will convince him to ack my patch :)

--Andy
