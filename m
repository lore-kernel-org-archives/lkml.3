Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDPCPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:15:06 -0400
Received: from mano-163-56-shared.jabatus.fr ([109.234.163.56]:42860 "EHLO
	mano-163-56-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbaDPCPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:15:03 -0400
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: E89329D284B0.A3B04
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534DE72B.7020508@manux.info>
Date: Wed, 16 Apr 2014 04:12:59 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][1/11][MANUX] Kernel compatibility : ext2
References: <534D3753.6080601@manux.info> <20140415200457.GH4456@thunk.org> <534DA90C.7000507@manux.info> <20140415222747.GN4456@thunk.org>
In-Reply-To: <20140415222747.GN4456@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/04/2014 00:27, Theodore Ts'o a écrit :
> On Tue, Apr 15, 2014 at 11:47:56PM +0200, Emmanuel Colbus wrote:
>> My OS heavily uses chroots for security purposes (these are not true
>> Linux-like chroots, but this isn't relevant). One of the issues of
>> chroots is that one can escape from them, by simply having one process
>> open a fd towards a directory, another one move the directory inside a
>> second directory located outside of the first process' chroot, and then
>> have the first process perform enough fchdir(fd, ".."); or something of
>> the like.
> 
> If there a process which is out side of the chroot which is
> cooperating to help someone breakout of the chroot, that means you
> have a bad actor who is outside of the chroot already.  So why bother
> worrying about this case?

Well, in my OS, every process is chrooted. Thus, in this case, the bad
actor is trying to help another bad actor leave its chroot to access the
whole machine; which is what I'm trying to prevent.

> 
> The more interesting way to break out of a crhoot, which doesn't
> require a 2nd process to help you escape, is to chroot while inside a
> chroot:
> 
> 	www.bpfh.net/simes/computing/chroot-break.html
> 
> And if you care about this problem, Linux has a much more general
> solution using mount namespaces.  FreeBSD has its own a solution
> involving restrictions on chroot:
> 
> www.freebsd.org/cgi/man.cgi?query=chroot&sektion=2&apropos=0&manpath=FreeBSD+4.0-RELEASE

I also have my solution. You see, although I talk about them as
"chroots", these constructions are substantialy different from the
chroots mandated by POSIX; and in fact, I neither support POSIX' chroot
nor Linux' chroot() syscall. (Yes, I understand this is both a Linux and
a POSIX incompatibility, and I fully acknowledge it. And I'm deeply
sorry about this, but I believe I will not be able to change it, because
this call simply doesn't seems to be compatible with my security model.
Unless and until I find a way to put a POSIX chroot on top of my totally
and definitely unPOSIX ones, that is.)

So, my own syscall is named xchroot(), and it simply defeats this
attempt by, as a side effect, CLOSING all the file descriptors of the
caller that refer to directories, and setting the new current working
directory of the caller to the new root.

(Well, in fact, the caller can ask it to keep some of these descriptors,
but to do so, he has to indicate where he wants the corresponding
directories to appear in its new chroot. So this approach is a lost cause.)


~~~~~~~~~~~~~~~~~~~~~

To make things clearer, my goal was to create a Linux-compatible
operating system able to withstand userspace zero-day attacks.
*Withstand* being a key word here, as I did not intended to *prevent*
them : all I wanted was to prevent, as much as possible, an exploit in
an application from giving access to the rest of the computer. (As an
example, the recent heartbleed exploit is something my conception would
have done exactly *nothing* against.)

To do this, I've introduced several new elements :

- Directory hardlinks. I mentionned them before.
- Rootlinks. These are asymetric links within the filesystem that
associate a regular file with a directory. They only exist within my
ext2l partitions. (Again, it's a re-use of the fragment address field.)
- A new virtual filesystem, named /... (slash-triple-point). Any process
can access it, even if it doesn't appears in its root, and its content
depends upon the identity of the process that looks into it (well, more
exactly, upon the identity of the xchroot he's running within).
- A new syscall, xchroot(), that allows the use of the aforementionned
creations (rootlinks and /... ). That is, thanks to it, a process can :
 - ask the kernel to chroot it in the directory that's being targetted
   by the rootlink associated with the file this process is currently
   executing. (Of course, if there's no such thing, this call simply
   fails.)
 - ask the kernel to put new files within its /... filesystem. That is,
   it can tell the kernel "put the file ./my_file.txt in my /...
   filesystem, under the name /.../rocknroll/blues.dat." The kernel will
   comply, and the process will then be able to access the file
   through this new name;
 - and of course, it can ask it to remove some or all the files within
   its own /... , and ask to be chrooted in a directory identified by
   its name.
- Little wrappers, called launchers, that are used to launch all the
programs outside one's xchroot.
- A new packaging system, that allows the use of directory hardlinks and
the construction of these launchers using a reasonably secure format
(because I also wanted to fortify the system against deliberately
hostile packages).

Also, all the user's home directories are made so that, to their shell,
they look like they are within /... . My own $HOME variable, for
example, is /.../home/ecolbus .

Then, the things happen this way. At installation, the packaging system
looks up which files and directories the new package needs,
cryptographically checks that it has been allowed to declare such
dependancies (well, actually, I haven't done this part yet... But that's
what it ought to do), and installs them using hardlinks towards the
actual files. Then, it looks for the file required to build the little
launcher, and feeds it to the launcher builder, which builds and
installs it. Then, the packaging system creates hardlinks towards the
launcher in the roots of all the programs that have a dependancy on the
first one.

When another program (say, the user's shell) tries to call the
newly-installed one (let's call him /bin/cat), it looks up its $PATH as
usual, and finds it. Except he actually only found the launcher, not the
true program, so it's the launcher that gets called.

The launcher then parses its command line, and determine which ones of
its arguments are true files, and which ones are simply options (like
-n). It then calls xchroot(), by asking the kernel to put the required
files, if any, in its /... partition, AND to remove all the others, AND
to change its root to the directory that's targetted by the rootlink
associated with the launcher's file.

The kernel dutifully performs its work, making the files available
within /... and changing its caller's root directory to the required
directory, which turns out to be the true cat's root directory. After
this, the launcher performs an execve() on cat's true binary.

This one performs its operations as usual, opening the file within /...
as its command line requests it, doing its work on it, and then exiting.

This way, the program has been able to perform its operation without
either the caller or the called processes ever having access to each
other's root. Also, even if there had been a zero-day exploit within the
called process (cat), the exploit would only have gained access to cat's
root directory and the file that contained it, which is completely useless.

(Of course, if the user had specified more than one file on the command
line, then it could have accessed the other ones. But I still consider
that this is a very serious mitigation compared to giving full access to
the user's entire homedir).

Also, as a nice side effect, even if the caller and the called had had
incompatible dependancies (say one depends on the glibc, the other on
the uclibc), this would have been unproblematic, and no process would
have noticed it.


Next, to answer the most obvious questions :

- How do you determine which file a process is executing?
I simply remember this information from the time of its last execve().

- Are the launchers statically compiled?
Of course they are, otherwise the library attack would be quite obvious :-).

- Do two processes that share the same root directory also share the
same /... files?
No, unless none of them ever called xchroot() successfully since they
were separated by fork().


- what about chroot() privileges?
Since using it can't lead to an escape, my xchroot() syscall is
completely unprivileged.


- what about directory-refering fd transfer using UNIX sockets?
This isn't yet handled, but when it will be, these will either be
disallowed or implemented in such a way that they can't be used for an
escape.


- Why put the manipulation of /... and of the process' root
directory within the same syscall?

That's because of the use case of "hey, dear kernel, I have this file
descriptor that refers to a directory, and I would like to keep it after
my root has been changed. Could you please refrain from closing it, and
instead make it appear in my /... , as /.../what/ever ?"

Since the closure of the file descriptors that refer to directories has
to be a side effect of the syscall that changes the process' root, BUT
the request to make it appear within /... can only appear within a
syscall that alters /... , there had to be a single syscall that
performed both operations.

That being said, it is possible to use this syscall to only perform one
of these operations at a time.


- What if somebody tries to do mkdir("..."); within somebody else's root ?
Nice try, but I've decided to disallow the use of this name in my ext2l
partitions. I don't think this violates any standard, because in fact,
if I'm not mistaken, even the "." and ".." entries aren't specified, so
I don't see why adding "..." to the list of disallowed file names would
be an issue. (In fact, I've decided to mark as reserved *any* file name
that contains no character different from '.'; the other ones being
reserved for extensions. Not that I had any intent to use them, though;
I just thought it would be nice to have such reserved names.)
This might be a little Linux ABI breakage, though. Sorry.


- Does this has a cost?

Oh, yes :
  - the launchers slightly slow down the system. Not that much, since
they perform very few syscalls, but that's obviously higher than 0. It's
less than the glibc's initialization, though.
   - more importantly, using these functionnalities requires using an
unified package system, so that's so much lost in terms of adaptability.
   - also, my OS can only use my ext2l partitions as root partition.
   - far, far, far more importantly than all of this, this breaks POSIX.
And I know it, and fully assume it. And it's not only about the chroot()
syscall.

The big, BIG issue happens when an application does something like :
"ls /bin/true".

Since ls has no dependancy on /bin/true, there is no such file in ls'
root directory. Since the files can only be transfered within the /...
filesystem, this operation *cannot* succeed.

Fortunately, my launchers have special code that allows them to try to
deal with this situation. What they do is :
 - they choose a new name, different from all the existing ones, and
make the requested file appear in a directory that carries this new name
in /... ;
- and they *alter* their command line, so that it seems like they have
been asked to work on the new name.

The result is that the caller sees something like this :

$ ls /bin/true
/.../??/true
$

This is a clear-cut POSIX violation, and as I said, I fully assume it.
That's because I consider that security is about tradeoffs, and that the
loss of standardization and compatibility that this implies is more than
offset by the gains in terms of security that this architecture
provides. That's my opinion, and I'm sticking to it.

All I could do was to put everybody's homedir within /... , so that this
use case remains marginal - limited to operations performed by an
application on a file upon which it has a dependancy and manual commands
by the user.

~~~~~~~~~~~~~~~~~~~


> 
> 
>> Alright, then. Here's what I plan to do :
>> - In the short term, I'm going to continue with what I'm currently doing
>> with ext2 filesystems, but warn my users against mounting such a
>> filesystem in read-write mode if they're also mounting it with ext4 and
>> exporting it with NFS;
> 
> The main issue is what is the goal of your creating your own OS?  If
> it's for your own edication, that's great.  Have fun, it's a great way
> to learn.  If you're going to actually try to market this to other
> users, you should make sure you understand how much effort it takes to
> support a new file system, let alone a new operating system.  Hurd
> tried to go down a path somewhat like yours, and it's taken them
> years, and the result from a performance point of view is still pretty
> bad.  Keep in mind that ext2 has many limitations, including crash
> recovery, performance, and scalability.

Well, when I started doing this OS, this was exactly my goal : self
education. I've to say it worked well. And then, I also decided to try
my ideas about strong security, so I tried them. I had many failures,
and it took me a very long amount of time to find a workable concept,
but in the end, I got the whole thing working and self-hosted. And then
I noticed that, much to my surprise, I had actually succeeded into
getting a minimal working OS with these securities, so I decided to
publish it.

> 
> If you are planning on creating a production quality OS using ext2 as
> its base, it does seem a little naive, though.

Hmmm... No, I understand journalization will eventually be needed. But
then, until this happens, I've time...

Emmanuel
