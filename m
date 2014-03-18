Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaCRNDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:03:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45166 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaCRNDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:03:10 -0400
Message-ID: <53283D7A.1020409@gmail.com>
Date: Tue, 18 Mar 2014 13:35:06 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: mtk.manpages@gmail.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: For review: open_by_name_at(2) man page
References: <53271B69.3000305@gmail.com> <20140318090007.3adee3d0@notabene.brown>
In-Reply-To: <20140318090007.3adee3d0@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 11:00 PM, NeilBrown wrote:
> On Mon, 17 Mar 2014 16:57:29 +0100 "Michael Kerrisk (man-pages)"
> <mtk.manpages@gmail.com> wrote:
> 
>> Hi Aneesh, (and others)
>>
>> Below is a man page I've written for name_to_handle_at(2) and
>> open_by_name_at(2). Would you be willing to review it please,
>> and let me know of any corrections/improvements?
>>
>> Thanks,
>>
>> Michael
> 
> Thanks for writing this Michael.  The fact that I can only find very small
> points to comment on reflects the high quality...

Thanks, Neil. But there was at least one good clanger below :-}.

> 
>> Otherwise,
>> .IR dirfd
>> must be a file descriptor that refers to a directory, and
>   ^^^^^^^
>> .I pathname
>> is interpreted relative to that directory.
> 
> As you clarify later, "must be" is not correct.  Maybe this is just an issue
> of style, in which case you should obviously keep a consistent style across
> man pages, but to me it sounds wrong.  I would use "is generally" or similar.

Yep, good point. In fact, what I did was rewrite that section completely, to 
more clearly describe the distinct cases based on dirfd/pathname/AT_EMPTY_PATH.


>> The
>> .IR mountdirfd
>> argument is a file descriptor for a directory under
>> the mount point with respect to which
>> .IR handle
>> should be interpreted.
> 
> mountdirfd does not have to be for a directory.  It can be for any object in
> the filesystem.  And I would say "in", not "under".
> If /foo and /foo/bar are both mountpoints, and I want to look up a
> filehandle for the filesystem mounted at /foo, then opening "/foo/bar"
> wouldn't work even though /foo/bar is "under" /foo.  And opening "/foo" would
> work even though "/foo" is not under "/foo/" (is it?).

Good catch. I got deceived by the name of the argument, which in the kernel
source is indeed 'mountdirfd', implying it must be a descriptor for a directory.
I'll rename the argument in the man page to 'mount_fd' and fix the description 
as you suggest here:

>   The
>   .IR mountfd
>   argument is a file descriptor for any object (file, directory, etc.) in the
>   filesystem with respect to which

I did s/filesystem/mounted filesystem/

>   .IR handle
>   should be interpreted.
> 
> ??
>> .B ESTALE
>> The specified
>> .I handle
>> is no longer valid.
> 
> ESTALE is also returned if the filesystem does not support file-handle ->
> file mappings.
> On filesystems which don't provide export_operations (/sys /proc ubifs
> romfs cramfs nfs coda ... several others) name_to_handle_at will produce a
> generic handle using the 32 bit inode and 32 bit i_generation.

Are you sure about this? When I try name_to_handle_at() on /proc and
/sys, it gives an error (EOPNOTSUPP). I haven't tested the other
FSes though, so maybe some of them do what you say.

> open_by_name_at given this (or any) filehandle will fail with ESTALE.
> I don't know how best to include this in the documentation.  Maybe a note
> earlier noting that some filesystems do not support open_by_name_at(), and
> you cannot programatically determine which do except by trying.
> At the same time note that a file handle can become in valid if a file is
> deleted or for any other reason as determined by the filesystem, and that the
> error is the same as for when the filesystem doesn't support open_by_name_at.

I've added text about invalid file handles into NOTES, and noted that not all
FSes support the production of file handles, but haven't noted ESTALE for the
latter, since I don't yet know if your statement above is true for some 
filesystems.


>> For example, one can use the device name in the fifth field of the
>> .I mountinfo
>> record to search for the corresponding device UUID via the symbolic links in
>> .IR /dev/disks/by-uuid .
>> (A more comfortable way of obtaining the UUID is to use the
>> .\" e.g., http://stackoverflow.com/questions/6748429/using-libblkid-to-find-uuid-of-a-partition
>> .BR libblkid (3)
>> library, which uses the
>> .I /sys
>> filesystem to obtain the same information.)
> 
> Does it?  My understanding from "man libblkid" (it is a while since I've read
> the code) is that it either uses info in /dev/disks/by-* or reads directly
> from the block devices (maybe using /sys to find them?) and interprets the
> superblock to extract a UUID.

Thanks (and to Christoph) -- I'll just remove the words "which uses the /sys
filesystem to obtain the same information"

>> Now delete and re-create the file with the same inode number;
>> .BR open_by_handle_at ()
>> recognizes that the file referred to by the file handle no longer exists.
>>
>> .in +4n
>> .nf
>> $ \fBstat \-\-printf="%i\\n" cecilia.txt\fP       # Display inode number 
>> 4072121
>> $ \fBecho 'Warum?' > cecilia.txt\fP
>> $ \fBstat \-\-printf="%i\\n" cecilia.txt\fP       # Check inode number
>> 4072121
>> $ \fBsudo ./t_open_by_handle_at < fh\fP
>> open_by_handle_at: Stale NFS file handle
> 
> Something is very wrong here.
>    echo foo > somefile
> does not "delete and re-create" the file.  It opens and truncates.
> That operation should not invalidate the filehandle on any sane filesystem.

Indeed! I don't know quite what I was smoking as I reviewed that piece.
In fact, I started writing this page a long time ago, but then other 
events intervened, and it was a long time before I came back to it recently.
Certainly, when I produced that shell session log, things proceeded
(almost) as shown. I'm guessing that what happened is that I by 
accident edited out a line

    rm cecilia.txt

just before

    echo 'Warum?' > cecilia.txt

Fixed now. (In that case of course, it is of course a matter of chance
whether the pathname is re-created with the same i-node number, but if 
you are quick, it often is. I'll add some explanation to the page.)

>>     if (argc > 1)
>>         mount_fd = open(argv[1], O_RDONLY | O_DIRECTORY);
> 
> O_DIRECTORY is not appropriate, as mentioned earlier.

Fixed (in two places).

Thanks for the review, Neil. That helped fix a lot of problems in the page.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
