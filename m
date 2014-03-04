Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaCDTS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:18:28 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:59170 "EHLO
	homiemail-a20.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754192AbaCDTS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:18:27 -0500
Message-ID: <5a4dc13aac49671c68b4dfb3885e6b69.squirrel@webmail.novalis.org>
In-Reply-To: <daed65ee080e4cc417c87f34af8447f2.squirrel@webmail.novalis.org>
References: <daed65ee080e4cc417c87f34af8447f2.squirrel@webmail.novalis.org>
Date: Tue, 4 Mar 2014 14:18:27 -0500
Subject: Re: PROBLEM: Inotify leaks file descriptors.
From: "David Turner" <novalis@novalis.org>
To: "David Turner" <novalis@novalis.org>
Cc: "John McCutchan" <john@johnmccutchan.com>, "Robert Love" <rlove@rlove.org>,
        "Eric Paris" <eparis@parisplace.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20140304141826_80745"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20140304141826_80745
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

(script attached)
On Tue, March 4, 2014 2:09 pm, David Turner wrote:
> I apologize for the slightly convoluted reproduction steps here,
> but I was not easily able to find a simpler test case in the
> time that I had available.
>
> First, you'll need Facebook's watchman:
> https://github.com/facebook/watchman
>
> Build and install it.  Then run the attached Python script.
> After a few hundred lines, you'll start to see errors of the form
> inotify_init error: Too many open files.  That could just
> indicate that watchman is leaking, but I think that's not what's
> going on, because killing watchman does not fix the problem.
>
> To demonstrate, kill the python script, then kill watchman.
> Then run tail -f /etc/hosts.  You'll get "tail: inotify cannot be
> used, reverting to polling: Too many open files" (you may need to
> run a few tails to see the error).  In fact, the only way I have
> found to get back to normal is to reboot.
>
> I tried increasing the ulimit to 10000 (from the default 1024).
> The error still happens, but it seems to take a bit longer.
>
> I have tried on a couple of Ubuntu kernels:
>
> Linux version 3.11.0-17-generic (buildd@toyol) (gcc version 4.6.3
> (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #31~precise1-Ubuntu SMP Tue Feb 4
> 21:25:43 UTC 2014
>
> And Ubuntu's 3.8.0-36-generic (it's not running right now so I can't gi=
ve
> the full version).
>
> I've also tried a stock kernel built from source (in a virtualbox):
>
> Linux version 3.13.5 (dturner@dturner-virtualbox) (gcc version 4.8.1
> (Ubuntu/Linaro 4.8.1-10ubuntu8) ) #1 SMP Mon Mar 3 20:41:51 EST 2014
>
> I get the error on all of these.
> There is no output in dmesg.
>
> I was running these tests on ext4 filesystems:
> (for the Ubuntu kernels)
> /dev/mapper/stross--vg-root on / type ext4 (rw,errors=3Dremount-ro)
> (for the stock kernel, in the virtualbox)
> /dev/sda1 on / type ext4 (rw,errors=3Dremount-ro)
>
> Please let me know if you need any more information.
>
> FWIW, I did find this bug while googling, but it was on older kernels a=
nd
> was allegedly fixed:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1101666
>
>
>

------=_20140304141826_80745
Content-Type: text/x-python; name="abuse-watchman.py"
Content-Disposition: attachment; filename="abuse-watchman.py"
Content-Transfer-Encoding: quoted-printable

#!/usr/bin/python

from atomicinteger import AtomicInteger
from json import loads, dumps
from random import random
from subprocess import call, check_output
from tempfile import mkdtemp
from time import sleep, time

import os
import socket
import stat
import threading

#from https://github.com/littlehedgehog/base/blob/master/atomicinteger.py
class AtomicInteger:
    def __init__(self, integer =3D 0):
        self.counter =3D integer
        self.lock =3D threading.RLock()
        return

    def increase(self, inc =3D 1):
        self.lock.acquire()
        self.counter =3D self.counter + inc
        self.lock.release()
        return

    def decrease(self, dec =3D 1):
        self.lock.acquire()
        self.counter =3D self.counter - dec
        self.lock.release()
        return
   =20
    def get(self):
        return self.counter


def get_sockname():
    result =3D check_output(["watchman", "get-sockname"])
    result =3D loads(result)
    return result['sockname']

def connect():
    sockname =3D get_sockname()
    sock =3D socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(sockname)
    sock.setblocking(False)
    return sock

def watch(sock, directory):
    watch =3D ['watch', directory]
    sock.sendall(dumps(watch) + "\n")
    result =3D readline(sock)
    result =3D loads(result)
    if not result.get("watch"):
        print result

def readline(sock):
    message =3D []
    start =3D time()
    while True:
        elapsed =3D time() - start
        if elapsed > 5:
            print "We have been waiting a very long time for data from wa=
tchman. We have so far: %s" % "".join(message)
        try:
            data =3D sock.recv(1024, socket.MSG_DONTWAIT)
            if "\n" in data:
                message.append(data[:data.index("\n")])
                break
        except socket.error:
            pass
        sleep(0.001)
    return "".join(message)

def since(sock, directory, since=3D"c:1:2:3:4"):
    expression =3D {'since' : since}
    watch =3D ["query", directory, expression]
    sock.sendall(dumps(watch) + "\n")
    message =3D readline(sock)
    result =3D loads(message)
    if "error" in result:
        print "Error in since: %s (since =3D %s)" % (result["error"], sin=
ce)
    return result

def create(sock, directory=3DNone):
    directory =3D mkdtemp(dir=3Ddirectory)
    watch(sock, directory)
    return directory

def touch(directory):
    f =3D open(os.path.join(directory, "file-%s" % random()), "w")
    f.write("x")
    f.close()

def isdir(f):
    result =3D os.lstat(f)
    return stat.S_ISDIR(result.st_mode)

def recursive_rmdir(directory):
    for f in os.listdir(directory):
        qualified =3D os.path.join(directory, f)
        if isdir(qualified):
            recursive_rmdir(qualified)
        else:
            os.unlink(qualified)
    os.rmdir(directory)

nthreads =3D AtomicInteger()
runs =3D AtomicInteger()

def run():
    nthreads.increase()
    runs.increase()
    directory =3D None
    sock =3D None
    try:
        print "RUN: %d %d" % (runs.get(), nthreads.get())
        sock =3D connect()
        directory =3D create(sock)

        result =3D since(sock, directory)
        assert "files" not in result or len(result["files"]) =3D=3D 0
        clock =3D result.get("clock")
        if not clock:
            print "Failed since: %s" % result
        assert clock

#this stanza is only necesary on unbuntu 3.11; on 3.15, it can be skipped
        touch(directory)
        result =3D since(sock, directory, clock)
        assert result["clock"] !=3D clock
        clock =3D result["clock"]
        assert len(result["files"]) =3D=3D 1

        sleep(0.1)

#ditto
        for i in range(5):
            touch(directory)
        result =3D since(sock, directory, clock)
        assert result["clock"] !=3D clock
        if len(result["files"]) < 5:
            print result

    finally:
        if sock:
            sock.close()
        if directory:
            recursive_rmdir(directory)
        nthreads.decrease()

def threaded(target, *args, **kwargs):
        thread =3D threading.Thread(target=3Dtarget, args=3Dargs, kwargs=3D=
kwargs)
        thread.start()

while True:
    if nthreads.get() < 15:
        threaded(run)
    else:
        sleep(0.1)
------=_20140304141826_80745--


