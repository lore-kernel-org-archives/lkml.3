Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab3APWDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:03:19 -0500
Received: from mout.gmx.net ([212.227.17.20]:52325 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab3APWDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:03:17 -0500
Cc: thorsten.kohfeldt@gmx.de
Content-Type: text/plain; charset="utf-8"
Date: Wed, 16 Jan 2013 23:03:13 +0100
From: "Thorsten Kohfeldt" <thorsten.kohfeldt@gmx.de>
Message-ID: <20130116220313.32260@gmx.net>
MIME-Version: 1.0
Subject: sys/net/core: rmem_max and wmem_max vs rmem_default and wmem_default
To: linux-kernel@vger.kernel.org
X-Authenticated: #3890321
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+HKbpZtJSHSUNSLnBFeHqO4/mF5x80iqNafLG3w7
 85uklMXkUDLSGvfzMadqNEdjIlXZxFPIZ5ug== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 9kaFcP5teSEqaPA/UHQh4LB+IGRvbwAj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I doubt that the subsequent irritating findings concerning relations between the following system variables are completely 'by design'.

/proc/sys/net/core/rmem_max
/proc/sys/net/core/wmem_max
/proc/sys/net/core/rmem_default
/proc/sys/net/core/wmem_default

Unless someone is kind enough to enlighten me about my error, I plead for an approach to straighten things out.
(I have added a script which helps reproducing my claims/findings.)

- rmem_default (wmem_default) is allowed to be larger than rmem_max (wmem_max). This is not a theoretical issue, as with current kernels and memory provision above 512M rmem_max and wmem_max are limited (during system startup) to 131071 (i.e. ((128 * 1024) - 1)) by sk_init() in sock.c.
Note that on a system with LESS memory the _max values CAN be larger after default system startup.
This is not intuitive.

- why is the limit 2^n - 1 in the above paragraph ?
I doubt this limit in general is somehow related to 'buffer bloat precautions', so why is there an 'auto config' limit for cases where memory does not seem to be the bottle neck ?
Why are the default values NOT adjusted in that case ?
This is not intuitive.

- if a UDP connection is made without calling setsockopt(SO_RCVBUF), rmem_default is used as the buffer size. If setsockopt IS called, the requested value is doubled (this is well explained in sock.c) then limited by rmem_max. Why is is rmem_default in the first mentioned case NOT doubled ?
This is not intuitive.

- above paragraph is also true for SO_SNDBUF vs wmem_max and wmem_default.

- if Xmem_max is less than (currently half of) Xmem_default, then a connection being made without setsockopt() calls can end up with a larger buffer than connections made with a specific setsockopt() request for a large buffer size.
This is not intuitive.



I want to suggest the following 'fixes' to sock.c in order to get a more intuitive behaveiour:

a) init_sk() should act differently, not limiting systems with more memory stricter than systems with less memory.

b) sysctl_rmem_default and sysctl_wmem_default should also be doubled internally (just like new values for SO_xxxBUF) before being used for assigning a default buffer size to a new connection.

c) independently of how operators would like to use the mem_max values as 'online switches', these values should always also limit the default buffer sizes which are in effect without setsockopt() calls. This could be done with or without reflecting that influence in
/proc/sys/net/core/?mem_default


NOTE that this discussion for the time being concerns UDP. TCP involves more variables, even extending the problem, which should be dealt with later.



Here is one 'funny' example of how the variables are currently interpreted:
(Note that I have manually tuned the variables to make my point).


$ net-core-xmem_-info 

Linux version 3.5.0-21-generic (buildd@akateko) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #32~precise1-Ubuntu SMP Thu Dec 13 20:30:13 UTC 2012

running tests on address 192.168.2.147 ...

/proc/sys/net/core/rmem_max:    	40000
/proc/sys/net/core/wmem_max:    	50000
/proc/sys/net/core/rmem_default:    	400000
/proc/sys/net/core/wmem_default:    	500000

iperf ist /usr/bin/iperf

probing MAXIMUM RECEIVE buffer size (setsockopt SO_RCVBUF=1GB) ...
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size: 78.1 KByte (WARNING: requested 1.00 GByte)

probing MAXIMUM SEND buffer size (setsockopt SO_SNDBUF=1GB) ...
------------------------------------------------------------
Client connecting to 192.168.2.147, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size: 97.7 KByte (WARNING: requested 1.00 GByte)

probing DEFAULT RECEIVE buffer size (NO setsockopt) ...
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:  391 KByte (default)

probing DEFAULT SEND buffer size (NO setsockopt) ...
------------------------------------------------------------
Client connecting to 192.168.2.147, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  488 KByte (default)



And here is the script (it does not modify anything in your system):
--------------------------- snip ---------------------
#!/bin/bash

ip_addr=$1

uflag=-u

function get_one_local_addr ()
{
  LANG=C ifconfig | sed s/\ addr:/@/ | cut -d @ -f 2 \
  | grep ^192[.]168[.]\\\|^172[.]1[6-9][.]\\\|^172[.]2[0-9][.]\\\|^172[.]3[01]\\\|^10[.] \
  | cut -d " " -f 1 | sort -r | head -1
}

if ! LANG=C ifconfig | grep " inet addr:$ip_addr " >/dev/null
then
  if [ -z "$ip_addr" ]
  then
    # no address given
    ip_addr=`get_one_local_addr`
  else
    # given address does not seem useful
    ip_addr=
  fi
  if [ -z "$ip_addr" ]
  then
    echo "Please provide a valid local IP V4 address as parameter 1"
    exit 1
  fi
fi

echo
cat /proc/version
echo
echo "running tests on address $ip_addr ..."
echo

for i in max default
do
  for j in r w
  do
    sysvar=${j}mem_$i
    syspath=/proc/sys/net/core/$sysvar
    echo -e "$syspath:    \t`cat $syspath`"
  done
done
echo

type iperf || exit
echo

echo "probing MAXIMUM RECEIVE buffer size (setsockopt SO_RCVBUF=1GB) ..."
iperf $uflag -s -w $((1024*1024*1024)) | head -4 &
sleep 1
echo

echo "probing MAXIMUM SEND buffer size (setsockopt SO_SNDBUF=1GB) ..."
iperf $uflag -c $ip_addr -t 10 -w $((1024*1024*1024)) | head -4 &
sleep 1
echo

kill -1 `pgrep -P $$`
sleep 1

echo "probing DEFAULT RECEIVE buffer size (NO setsockopt) ..."
iperf $uflag -s | head -4 &
sleep 1
echo

echo "probing DEFAULT SEND buffer size (NO setsockopt) ..."
iperf $uflag -c $ip_addr -t 10 | head -4 &
sleep 1
echo

kill -1 `pgrep -P $$`
sleep 1
--------------------------- snap ---------------------
