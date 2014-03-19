Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274AbaCSNQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:16:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826AbaCSNQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:16:40 -0400
Date: Wed, 19 Mar 2014 14:16:37 +0100
From: Jan Kara <jack@suse.cz>
To: David Turner <novalis@novalis.org>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Inotify leaks file descriptors.
Message-ID: <20140319131637.GA17852@quack.suse.cz>
References: <daed65ee080e4cc417c87f34af8447f2.squirrel@webmail.novalis.org>
 <d31202acbd0097307fb52d8239466308.squirrel@webmail.novalis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d31202acbd0097307fb52d8239466308.squirrel@webmail.novalis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-03-14 14:18:08, David Turner wrote:
> (script attached)
> On Tue, March 4, 2014 2:09 pm, David Turner wrote:
> > I apologize for the slightly convoluted reproduction steps here,
> > but I was not easily able to find a simpler test case in the
> > time that I had available.
> >
> > First, you'll need Facebook's watchman:
> > https://github.com/facebook/watchman
> >
> > Build and install it.  Then run the attached Python script.
> > After a few hundred lines, you'll start to see errors of the form
> > inotify_init error: Too many open files.  That could just
> > indicate that watchman is leaking, but I think that's not what's
> > going on, because killing watchman does not fix the problem.
> >
> > To demonstrate, kill the python script, then kill watchman.
> > Then run tail -f /etc/hosts.  You'll get "tail: inotify cannot be
> > used, reverting to polling: Too many open files" (you may need to
> > run a few tails to see the error).  In fact, the only way I have
> > found to get back to normal is to reboot.
> >
> > I tried increasing the ulimit to 10000 (from the default 1024).
> > The error still happens, but it seems to take a bit longer.
> >
> > I have tried on a couple of Ubuntu kernels:
> >
> > Linux version 3.11.0-17-generic (buildd@toyol) (gcc version 4.6.3
> > (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #31~precise1-Ubuntu SMP Tue Feb 4
> > 21:25:43 UTC 2014
> >
> > And Ubuntu's 3.8.0-36-generic (it's not running right now so I can't give
> > the full version).
> >
> > I've also tried a stock kernel built from source (in a virtualbox):
> >
> > Linux version 3.13.5 (dturner@dturner-virtualbox) (gcc version 4.8.1
> > (Ubuntu/Linaro 4.8.1-10ubuntu8) ) #1 SMP Mon Mar 3 20:41:51 EST 2014
> >
> > I get the error on all of these.
> > There is no output in dmesg.
> >
> > I was running these tests on ext4 filesystems:
> > (for the Ubuntu kernels)
> > /dev/mapper/stross--vg-root on / type ext4 (rw,errors=remount-ro)
> > (for the stock kernel, in the virtualbox)
> > /dev/sda1 on / type ext4 (rw,errors=remount-ro)
> >
> > Please let me know if you need any more information.
> >
> > FWIW, I did find this bug while googling, but it was on older kernels and
> > was allegedly fixed:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1101666
> >
> >
> >
  So when I run your script on 3.14-rc5, I don't see any problems. So maybe
the problem really got fixed? BTW, I'll note that
/proc/sys/fs/inotify/max_user_instances is 128 on my system. Not sure what
it is on your system...

								Honza

> #!/usr/bin/python
> 
> from atomicinteger import AtomicInteger
> from json import loads, dumps
> from random import random
> from subprocess import call, check_output
> from tempfile import mkdtemp
> from time import sleep, time
> 
> import os
> import socket
> import stat
> import threading
> 
> #from https://github.com/littlehedgehog/base/blob/master/atomicinteger.py
> class AtomicInteger:
>     def __init__(self, integer = 0):
>         self.counter = integer
>         self.lock = threading.RLock()
>         return
> 
>     def increase(self, inc = 1):
>         self.lock.acquire()
>         self.counter = self.counter + inc
>         self.lock.release()
>         return
> 
>     def decrease(self, dec = 1):
>         self.lock.acquire()
>         self.counter = self.counter - dec
>         self.lock.release()
>         return
>     
>     def get(self):
>         return self.counter
> 
> 
> def get_sockname():
>     result = check_output(["watchman", "get-sockname"])
>     result = loads(result)
>     return result['sockname']
> 
> def connect():
>     sockname = get_sockname()
>     sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
>     sock.connect(sockname)
>     sock.setblocking(False)
>     return sock
> 
> def watch(sock, directory):
>     watch = ['watch', directory]
>     sock.sendall(dumps(watch) + "\n")
>     result = readline(sock)
>     result = loads(result)
>     if not result.get("watch"):
>         print result
> 
> def readline(sock):
>     message = []
>     start = time()
>     while True:
>         elapsed = time() - start
>         if elapsed > 5:
>             print "We have been waiting a very long time for data from watchman. We have so far: %s" % "".join(message)
>         try:
>             data = sock.recv(1024, socket.MSG_DONTWAIT)
>             if "\n" in data:
>                 message.append(data[:data.index("\n")])
>                 break
>         except socket.error:
>             pass
>         sleep(0.001)
>     return "".join(message)
> 
> def since(sock, directory, since="c:1:2:3:4"):
>     expression = {'since' : since}
>     watch = ["query", directory, expression]
>     sock.sendall(dumps(watch) + "\n")
>     message = readline(sock)
>     result = loads(message)
>     if "error" in result:
>         print "Error in since: %s (since = %s)" % (result["error"], since)
>     return result
> 
> def create(sock, directory=None):
>     directory = mkdtemp(dir=directory)
>     watch(sock, directory)
>     return directory
> 
> def touch(directory):
>     f = open(os.path.join(directory, "file-%s" % random()), "w")
>     f.write("x")
>     f.close()
> 
> def isdir(f):
>     result = os.lstat(f)
>     return stat.S_ISDIR(result.st_mode)
> 
> def recursive_rmdir(directory):
>     for f in os.listdir(directory):
>         qualified = os.path.join(directory, f)
>         if isdir(qualified):
>             recursive_rmdir(qualified)
>         else:
>             os.unlink(qualified)
>     os.rmdir(directory)
> 
> nthreads = AtomicInteger()
> runs = AtomicInteger()
> 
> def run():
>     nthreads.increase()
>     runs.increase()
>     directory = None
>     sock = None
>     try:
>         print "RUN: %d %d" % (runs.get(), nthreads.get())
>         sock = connect()
>         directory = create(sock)
> 
>         result = since(sock, directory)
>         assert "files" not in result or len(result["files"]) == 0
>         clock = result.get("clock")
>         if not clock:
>             print "Failed since: %s" % result
>         assert clock
> 
> #this stanza is only necesary on unbuntu 3.11; on 3.15, it can be skipped
>         touch(directory)
>         result = since(sock, directory, clock)
>         assert result["clock"] != clock
>         clock = result["clock"]
>         assert len(result["files"]) == 1
> 
>         sleep(0.1)
> 
> #ditto
>         for i in range(5):
>             touch(directory)
>         result = since(sock, directory, clock)
>         assert result["clock"] != clock
>         if len(result["files"]) < 5:
>             print result
> 
>     finally:
>         if sock:
>             sock.close()
>         if directory:
>             recursive_rmdir(directory)
>         nthreads.decrease()
> 
> def threaded(target, *args, **kwargs):
>         thread = threading.Thread(target=target, args=args, kwargs=kwargs)
>         thread.start()
> 
> while True:
>     if nthreads.get() < 15:
>         threaded(run)
>     else:
>         sleep(0.1)
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
