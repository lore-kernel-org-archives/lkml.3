Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaECB2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 21:28:01 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54718 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaECB17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 21:27:59 -0400
Subject: [RFC]   An Immune System for Linux
From: Sterling Huxley <sterling.huxley@gmail.com>
Reply-To: Sterling.Huxley@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 May 2014 18:27:56 -0700
Message-ID: <1399080476.6338.7.camel@ball>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



		An Immune System for Linux


An Operating System does not know the origins of a program.  If requested,
the OS will run any program, every program, all programs.  This was
good in the old days when the logistics of distributing a program were
expensive, time consuming, and labor intensive.  Today a user need only
tap a few on-screen buttons and the app store downloads a new program
to your phone.  Just because the OS can run a program, doesn't mean it
should.  Lets use the idea of an immune system to prevent unauthorized
programs from running.

An OS immune system should protect a computer from both external and
internal malware attacks.  External attacks might come in the form
of programs on removable media like USB flash drives and SD cards.
Internal attacks might come from zero-day memory corruption and buffer
overflow bugs.

Use public key cryptography to frustrate external attacks.
Limit not-self programs ability to make OS system calls to frustrate
internal attacks.


1- Use public key cryptography to frustrate external attacks.

We can use public key cryptography to help the OS differentiate between
self programs with acceptable provenance and not-self programs with
questionable origins.  Force all code to prove its origin every time
it runs.

The cryptography is not about obfuscation.  It's obvious what the
contents of the encrypted file /bin/ls is.  This is about provenance.
Who's /bin/ls is it?

When a phone is built the manufacture creates a unique secret key /
public key pair.  The manufacture uses the secret key to scramble the
programs and libraries which are then loaded onto the phone.  The public
key is compiled into the OS.  The secret key is not put on the phone.

The programs on disk are scrambled, random bytes.  They don't look like an
executable and can't run.  When a user runs a program, the OS path goes
through exec() and binfmt_elf.c which reads in the program.  It's in
load_binary() that the scrambled program data is decrypted.  Now the
program is cleartext, it loads into ram, and will execute.  Malware does
not have the secret key and is not scrambled.  It's cleartext.  When the
malware cleartext is decrypted by load_binary(), it turns into ciphertext.
Ciphertext doesn't have the internal structure of an executable and
won't load into ram.  Even if, magically, it loads into ram, when the
OS jumps to main(), it is executing random bytes.  The malware program
can't do what the author intended.

When picking the secret key / public key pair use a key size appropriate
for the device.  There is a pyramid of devices:

billions  ^               ^                |   0           Big Keys
          |            /      \            |
          |          /  server  \          | number
  MIPS    |        /    desktop   \        |  sold
          |      /      laptop      \      |
    0     |    /     phone/tablet     \    v  billions     Little Keys
              --------------------------

Phone users won't wait more than a second or so for a program to start up.
Use a small key size appropriate to low powered phones and tablets.
Phones have a small key and are easier to attack but there are billions
and billions of them, each one requiring some effort to break a key or
somehow find a means around the decryption in exec().  As the power of
the device increases it can have a larger key size.  Malware might try to
attack a server but the server is using a big key and is harder to attack.
Servers might be a profitable target but they are heavily armoured.
Phones are lightly armoured and easier to defeat, but the reward may
not be worth the effort.



2- Limit not-self programs ability to make OS system calls.

	Consider the following pseudo-code:

	# assign random numbers to syscall symbolic constants
	$ for s in fork exit open close read write ; do
		echo "#define __NR_$s $RANDOM" >> asm/unistd_32.h
	done
	$ cat asm/unistd_32.h
	#define __NR_fork   9848
	#define __NR_exit  11041
	#define __NR_open   1857	// random 32-bit int
	#define __NR_close 30024
	#define __NR_read  27326
	#define __NR_write 31273
	$

	-------

	// In the kernel source files:
	struct syscall_struct {
		syscall_handler_t *func;
		unsigned int       tag;		// 0 to 4294967295
	};

	sys_call_table[]= {
		{ sys_fork,     __NR_fork },
		{ sys_exit,     __NR_exit },
		{ sys_open,     __NR_open },	// symbolic random number
		{ sys_close,    __NR_close },
		{ sys_read,     __NR_read },
		{ sys_write,    __NR_write },
	};

	-------

	// somewhere in entry_32.S
	// find the requested OS call using user supplied syscall number
	userrequest= %eax;			// get syscall # from stack
	for ( i= 0; i < __NR_syscall; i++ ) {
		if ( sys_call_table[i].tag == userrequest ) {
			return( sys_call_table[i].func() );
		}
	}
	send_sig(SIGKILL, current, 0);


The programs and libraries on each phone will be compiled using its own
header file with its unique and random symbolic constants.  Malware is
not built with, and does not know, the phones unique system call tags.
If malware makes a system call it will have to guess the tag number for
the OS service.  It has 1 chance in 4 billion of guessing the correct
tag number for the system call it wanted, and about 350 chances in 4
billion of getting any valid tag number.  The for-loop that searches
for a tag matching the user request will run through the entire system
call table and not find a match and then the malware or incompetently
written user program will receive a justly deserved kill signal.

Self programs never make this mistake.  They don't make OS calls directly.
They make library calls which then call the OS for them.  Only the library
writers have to get the system call numbers correct so that everyone else
can use the libraries.  And even library writers don't use the actual
magic numbers, they use the symbolic names.  So, only one programmer,
who builds the header file, has to get the magic numbers and symbolic
names correct.  The OS, apps and libraries are built with the same header
file so even that one programmer can't make a mistake in choosing an
incorrect random number.  How do you incorrectly choose a random number?
It is just a happy accident.


Today malware sees a mono-culture of potential targets.  By
implementing system calls with randomly chosen numbers we eliminate
the OS mono-culture.  Instead, malware will find itself in a diverse,
randomized, environment in which it must try to adapt.  But, it gets only
one mistake before it is killed.  If malware can not make any system
calls then it is trapped in the CPU without access to anything outside
of its own address space.  This can waste battery life but the malware
can not get to the user, disk, or network.

There is a performance hit with the for-loop.  Phones, tablets, laptops,
and desktops have only one user to respond to.  Changing system calls
from indexing to tag-based searches will not be noticed by the user.
In exchange for the minor performance hit a user is more protected from
foreign software.

This OS system call randomization can mitigate and limit memory corruption
attacks at the fundamental level of all OS system calls.

Instead of the order in mono-cultures, let's introduce some randomness.

Remember, end users are not developers.


Sterling Huxley
Sterling.Huxley@gmail.com


