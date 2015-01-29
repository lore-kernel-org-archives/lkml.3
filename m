Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbbA2ISY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:18:24 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59737 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbA2ISV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:18:21 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 29 Jan 2015 09:17:59 +0100
Message-ID: <CAKgNAkhyGQAi3tPdHky9+QRWgwPm9+0+THx2eqZC-1byaTNA-g@mail.gmail.com>
Subject: getrandom(2) man page for final review
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ted,

I've now merged the branch that contains the getrandom(2) page that
you initially contributed, Heinrich greatly enhanced, and to which I
also added a few pieces. If you have a chance to do a final review, it
would be most appreciated. If you are very short if time, then parts
I'd most like to have reviewed are the DESCRIPTION and the
"Interruption by a signal handler" subsection. I've provided a
rendered version of the page below, for ease of reading.

Cheers,

Michael

=====

NAME
       getrandom - obtain a series of random bytes

SYNOPSIS
       #include <linux/random.h>

       int getrandom(void *buf, size_t buflen, unsigned int flags);

DESCRIPTION
       The  getrandom() system call fills the buffer pointed to by buf
       with up to buflen random bytes.  These  can  be  used  to  seed
       user-space  random  number generators or for cryptographic pur‐
       poses.

       getrandom() relies on entropy gathered from device drivers  and
       other  sources  of  environmental noise.  Unnecessarily reading
       large quantities of data will have a negative impact  on  other
       users  of  the /dev/random and /dev/urandom devices.  Therefore
       getrandom() should not be used for Monte Carlo  simulations  or
       other  programs/algorithms  which  are doing probabilistic sam‐
       pling.

       By default, getrandom() draws  entropy  from  the  /dev/urandom
       pool.  This behavior can be changed via the flags argument.  If
       the /dev/urandom pool has been initialized, reads of up to  256
       bytes  will  always  return as many bytes as requested and will
       not be interrupted by signals.  No such  guarantees  apply  for
       larger  buffer  sizes.  For example, if the call is interrupted
       by a signal handler, it may return a partially  filled  buffer,
       or  fail  with  the  error EINTR.  If the pool has not yet been
       initialized, then the call blocks, unless GRND_RANDOM is speci‐
       fied in flags.

       The  flags argument is a bit mask that can contain zero or more
       of the following values ORed together:

       GRND_RANDOM
              If this bit is set, then random bytes are drawn from the
              /dev/random  pool instead of the /dev/urandom pool.  The
              /dev/random pool is limited based on  the  entropy  that
              can be obtained from environmental noise.  If the number
              of available bytes in /dev/random is less than requested
              in  buflen,  the  call returns just the available random
              bytes.  If no random bytes are available,  the  behavior
              depends  on  the  presence of GRND_NONBLOCK in the flags
              argument.

       GRND_NONBLOCK
              By default, if there are no random  bytes  available  at
              all (when reading from /dev/random), or the entropy pool
              has  not  yet  been  initialized  (when   reading   from
              /dev/urandom),  getrandom()  blocks until data is avail‐
              able.  If the GRND_NONBLOCK flag is  set,  then  getran‐
              dom()  instead  immediately returns -1 with errno set to
              EAGAIN.

RETURN VALUE
       On success, getrandom() returns the number of bytes  that  were
       copied  to the buffer buf.  This may be less than the number of
       bytes requested via buflen  if  GRND_RANDOM  was  specified  in
       flags  and  insufficient entropy was present in the /dev/random
       pool, or if the system call was interrupted by a signal.

       On error, -1 is returned, and errno is set appropriately.

ERRORS
       EINVAL An invalid flag was specified in flags.

       EFAULT The address referred to by buf is outside the accessible
              address space.

       EAGAIN The requested entropy was not available, and getrandom()
              would have blocked if the  GRND_NONBLOCK  flag  was  not
              set.

       EINTR  While  blocked  waiting for entropy, the call was inter‐
              rupted by a signal handler; see the description  of  how
              interrupted  read(2) calls on "slow" devices are handled
              with and without the SA_RESTART flag  in  the  signal(7)
              man page.

VERSIONS
       getrandom() was introduced in version 3.17 of the Linux kernel.

CONFORMING TO
       This system call is Linux-specific.

NOTES
   Maximum number of bytes returned
       As of Linux 3.19 the following limits apply:

       *  When  reading from /dev/urandom, a maximum of 33554431 bytes
          is returned by a single call  to  getrandom()  on  a  system
          where int has a size of 32 bits.

       *  When  reading  from  /dev/random,  a maximum of 512 bytes is
          returned.

   Initialization of the entropy pool
       The kernel collects bits of entropy from environment.   When  a
       sufficient  number  of  random  bits  has  been  collected, the
       /dev/urandom entropy pool  is  considered  to  be  initialized.
       This  state  is  normally reached early in the system bootstrap
       phase.

   Interruption by a signal handler
       A call to getrandom() can block only when  called  without  the
       GRND_NONBLOCK  flag.  When reading from /dev/urandom (GRND_RAN‐
       DOM is not set), blocking can occur if the entropy pool has not
       been  initialized  yet  or  if the requested number of bytes is
       large.  When reading from  /dev/random  (GRND_RANDOM  is  set),
       blocking occurs if not enough random bytes are available.

       The  behavior  when a call to getrandom() that is blocked while
       reading from /dev/urandom is interrupted by  a  signal  handler
       depends  on  the initialization state of the entropy buffer and
       on the request size, buflen.  If the entropy is  not  yet  ini‐
       tialized, then the call will fail with the EINTR error.  If the
       entropy pool has been initialized and the request size is large
       (buflen > 256), the call either succeeds, returning a partially
       filled buffer, or fails with the error EINTR.  If  the  entropy
       pool  has  been  initialized  and  the  request  size  is small
       (buflen <= 256), then getrandom() will  not  fail  with  EINTR.
       Instead,  it  will  return  all  of  the  bytes  that have been
       requested.

       When reading from /dev/random, blocking requests  of  any  size
       can  be  interrupted by a signal (the call fails with the error
       EINTR).

       Calling getrandom()  to  read  /dev/urandom  for  small  values
       (<= 256) of buflen is the preferred mode of usage.

       The  special  treatment  of small values of buflen was designed
       for compatibility with OpenBSD's getentropy() system call.

       The user of getrandom() must always check the return value,  to
       determine  whether either an error occurred or fewer bytes than
       requested were returned.  In the case where GRND_RANDOM is  not
       specified  and buflen is less than or equal to 256, a return of
       fewer bytes than requested should never happen, but the careful
       programmer will check for this anyway!

   Choice of random device
       Unless  you are doing long-term key generation (and perhaps not
       even then), you probably shouldn't be using  GRND_RANDOM.   The
       cryptographic  algorithms  used for /dev/urandom are quite con‐
       servative, and so should be sufficient for all  purposes.   The
       disadvantage of GRND_RANDOM is that it can block.  Furthermore,
       dealing with the partially fulfilled getrandom() requests  that
       can occur when using GRND_RANDOM increases code complexity.

   Emulating OpenBSD's getentropy()
       The  getentropy()  system call in OpenBSD can be emulated using
       the following function:

           int
           getentropy(void *buf, size_t buflen)
           {
               int ret;

               if (buflen > 256)
                   goto failure;
               ret = getrandom(buf, buflen, 0);
               if (ret < 0)
                   return ret;
               if (ret == buflen)
                   return 0;
           failure:
               errno = EIO;
               return -1;
           }

BUGS
       As of Linux 3.19, the following bug exists:

       *  Depending on CPU load, getrandom() does not react to  inter‐
          rupts before reading all bytes requested.

SEE ALSO
       random(4), urandom(4), signal(7)

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
