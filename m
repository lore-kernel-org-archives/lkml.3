Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbaCSNLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:11:30 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:35120 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872AbaCSNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:11:25 -0400
Message-ID: <53299776.6060305@gmail.com>
Date: Wed, 19 Mar 2014 14:11:18 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: mtk.manpages@gmail.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: For review: open_by_name_at(2) man page [v2]
References: <53271B69.3000305@gmail.com> <53284233.3050800@gmail.com> <4037316.YIp1ssalrz@vapier>
In-Reply-To: <4037316.YIp1ssalrz@vapier>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 03/19/2014 07:42 AM, Mike Frysinger wrote:
> On Tue 18 Mar 2014 13:55:15 Michael Kerrisk wrote:
>> The
>> .I flags
>> argument is a bit mask constructed by ORing together
>> zero or more of the following value:
>> .TP
>> .B AT_EMPTY_PATH
>> Allow
>> .I pathname
>> to be an empty string.
>> See above.
>> (which may have been obtained using the
>> .BR open (2)
>> .B O_PATH
>> flag).
>> .TP
>> .B AT_SYMLINK_FOLLOW
>> By default,
>> .BR name_to_handle_at ()
>> does not dereference
>> .I pathname
>> if it is a symbolic link.
>> The flag
>> .B AT_SYMLINK_FOLLOW
>> can be specified in
>> .I flags
>> to cause
>> .I pathname
>> to be dereferenced if it is a symbolic link.
> 
> this section is only talking about |flags|, and further this part is only 
> talking about AT_SYMLINK_FOLLOW.  so this last sentence sounds super 
> redundant.
> how about reversing the sentence order so that both are implicit like is done 
> in the openat() page and the description of O_NOFOLLOW ?

I'm not sure that I completely understand you here, but I agree that this could 
be better. I've rewritten somewhat.

>> .B ENOTDIR
>> The file descriptor supplied in
>> .I dirfd
>> does not refer to a directory,
>> and it it is not the case that both
> 
> "it" is duplicated

Fixed.


>> .SS Obtaining a persistent filesystem ID
>> The mount IDs in
>> .IR /proc/self/mountinfo
>> can be reused as filesystems are unmounted and mounted.
>> Therefore, the mount ID returned by
>> .BR name_to_handle_at (3)
> 
> should be () and not (3)

Fixed.

> side note: this seems like an easy error to script for ...

Yep, I've got some scripts that I run manually now and then to 
check for this sort of stuff.

>> $ \fBecho 'Kannst du bitte überlegen?' > cecilia.txt\fP
> 
> aber, ich spreche kein Deutsch :(
> 
> do we have a standard about sticking to english ?  i wonder if people are more 
> likely to be confused or to appreciate it ...

Fair enough. I'm too influenced by recent work on the locale pages (and 
family conversations ;-)). I'll switch it to English

>> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \\
>>                         } while (0)
> 
> i wonder if err.h makes sense now that this is a man page for completely 
> linux-specific syscalls :).  and you use _GNU_SOURCE.

I'm not really convinced about using these functions, but I'll reflect 
on it more.

>> int
>> main(int argc, char *argv[])
>> {
>>     struct file_handle *fhp;
>>     int mount_id, fhsize, s;
>>
>>     if (argc < 2 || strcmp(argv[1], "\-\-help") == 0) {
> 
> argc != 2 ?

Yes, some cruft crept in.

>>     /* Allocate file_handle structure */
>>
>>     fhsize = sizeof(struct file_handle *);
> 
> pretty sure this is wrong 

<blush>

> as sizeof() here returns the size of a pointer, not 
> the size of the struct.  it's why i prefer the form:
> 
> 	fhsize = sizeof(*fhp);
> 
> less typing and harder to screw up by accident.

Yep, changed.

> granted, the case below won't crash since the kernel only reads/writes 
> sizeof(unsigned int) and i'm not aware of any system where that is larger than 
> sizeof(void *), but it's still wrong :).
> 
>>     s = name_to_handle_at(AT_FDCWD, argv[1], fhp, &mount_id, 0);
> 
> another personal style: create dedicated variables for each arg you unpack out 
> of argv[1].  it's generally OK when you only take one arg, but when you get 
> more than one, you end up flipping back and forth between the usage trying to 
> figure out what index 1 represents instead of focusing on what the code is 
> doing.
> 	const char *pathname = argv[1];

Yup.

>>     fhsize = sizeof(struct file_handle) + fhp\->handle_bytes;
> 
> fhsize += fhp->handle_bytes ?
> 
> it's the same, but i think nicer ;)

Depends on your perspective. It relies on no one changing the code
so that fhsize is modified after the earlier initialization. And
also, with this line, I see exactly what is going on, in one place.
I'll leave as is.

>>     /* Write mount ID, file handle size, and file handle to stdout,
>>        for later reuse by t_open_by_handle_at.c */
>>
>>     if (write(STDOUT_FILENO, &mount_id, sizeof(int)) != sizeof(int) ||
>>             write(STDOUT_FILENO, &fhsize, sizeof(int)) != sizeof(int) ||
>>             write(STDOUT_FILENO, fhp, fhsize) != fhsize) {
> 
> seems like a whole lot of code spew for a simple printf() ?  you'd have to 
> adjust the other program to use scanf(), but seems like the end result would 
> be nicer for users to experiment with ?

Yes. I'd already reflected on exactly that and made a change to using text 
formats.

>> static int
>> open_mount_path_by_id(int mount_id)
>> {
>>     char *linep;
>>     size_t lsize;
>>     char mount_path[PATH_MAX];
>>     int fmnt_id, fnd, nread;
> 
> could we buy a few more letters for these vars ?  i guess fmnt_id is the 
> filesystem mount id, and fnd is "find".

When I was a kid, you had to pay a dollar for each letter...
(I've made a few changes.)

> also, getline() returns a ssize_t, not an int.

Fixed.

>>     FILE *fp;
>>
>>     fp  = fopen("/proc/self/mountinfo", "r");
> 
> only one space before the =

Yup.

> i would encourage using the "e" flag whenever possible in the hopes that 
> someone might start using it in their own code base.
> 
> 	fp = fopen("/proc/self/mountinfo", "re");

I'm of two minds about this. I foresee the day when I get a bug report that
says: "Why did you use 'e' here (or O_CLOEXEC)? It's not needed". So, I'm 
inclined to leave this.

>>     for (fnd = 0; !fnd ; ) {
> 
> in my experience, seems like a while() loop makes more sense when you're 
> implementing a while() loop ...
> 	fnd = 0;
> 	while (!fnd) {

Yup. ;-}.

>>         linep = NULL;
>>         nread = getline(&linep, &lsize, fp);
> 
> this works, but it's unusual when using getline() as it kind of defeats the 
> purpose of using the dyn allocation feature.
> 
> 	fnd = 0;
> 	linep = NULL;
> 	while (!fnd) {
> 		nread = getline(&linep, &lsize, fp);
> 		...
> 	}
> 	free(linep);
> 
> i don't think it complicates the code much more ?

Yes. Fixed.

>>         if (nread == \-1)
>>             break;
>>
>> 	nread = sscanf(linep, "%d %*d %*s %*s %s", &fmnt_id, mount_path);
> 
> indent is off here

Fixed.

>>     return open(mount_path, O_RDONLY | O_DIRECTORY);
> 
> O_CLOEXEC for funsies ?

See above comment.

>> int
>> main(int argc, char *argv[])
>> {
>>     struct file_handle *fhp;
>>     int mount_id, fd, mount_fd, fhsize;
>>     ssize_t nread;
>> #define BSIZE 1000
>>     char buf[BSIZE];
> 
> why not sizeof(buf) and avoid the define ?

Done.

>>     if (argc > 1 && strcmp(argv[1], "\-\-help") == 0) {
>>         fprintf(stderr, "Usage: %s [mount\-dir]]\\n",
>>                 argv[0]);
> 
> how about also aborting when argc > 2 ?

Yes.

>>     if (argc > 1)
>>         mount_fd = open(argv[1], O_RDONLY | O_DIRECTORY);
> 
> O_CLOEXEC ?

See comment above.

>>     nread = read(fd, buf, BSIZE);
>>     if (nread == \-1)
>>         errExit("read");
>>     printf("Read %ld bytes\\n", (long) nread);
> 
> yikes, that's a bad habit to encourage.  read() returns a ssize_t, so print it 
> out using %zd.

Calling it a bad habit seems a bit too strong. It's a habit conditioned by writing 
code that runs on systems that don't have C99. Less important these days, of course.
I've changed it.

>> .SH SEE ALSO
>> .BR blkid (1),
>> .BR findfs (1),
> 
> i don't have a findfs(1).  i do have a findfs(8) ...

Thanks. blkid(8) also, actually.

Thanks for the comments, Mike.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
