Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbaDBUDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:03:06 -0400
Received: from message.langara.bc.ca ([142.35.159.25]:34383 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030187AbaDBUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:03:04 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 16:03:04 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cyeoh@au1.ibm.com
Message-id: <fa9ecac225ee2.533c5ee6@langara.bc.ca>
Date: Wed, 02 Apr 2014 19:03:02 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Suggestion, "public process scoped interfaces"
X-Accept-Language: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have been reconsidering requirements and solutions brought up in my
post "How about allowing processes to expose memory for cross memory
attaching?". I now have a much clearer idea of what I want. I think
there is a need for publicly exposing process scoped
interfaces. Previous solutions such as cross memory attaching,
processes binding to ports, DBus and shared directories /run have
troubles with permissions, are not generic or work on a service
level. I suggest "public process scoped interfaces" as the solution,
that every process is give in it's own run directory in /proc for
publicly exposing services.

There is already an interface for cross memory attaching but the
interface has the same permissions constraints as ptracing. As well,
this solution is not generic and does not work for other kinds of
interfaces such as sockets or message queues. Furthermore, I believe
that this use case could be replaced by "public process scoped
interfaces" as follows. For example, in an MPI implementation a
process might create a file in /proc/self/run/openmp/queue (with only
user readable, writable permissions of course!) and map it into shared
memory. Then other processes would using that process's PID open the
file /proc/${PID}/run/openmp/queue, write to the file and then close
it. Unfortunately, that inflates the system call cost to three times
as much. Arguably, the cost could be mitigated by caching file
descriptors but it's likely that MPI implementations might continue
using the existing solution of cross memory attaching.

Many programs bind to ports to expose an interface for
communication. However, these interfaces are limited to internet
sockets. Moreover, multiple instances of the program have to fight
over the ports available. As well, there is no relation between the
process's PID and the port. Under "public process scoped interfaces"
any file interface can be used, each process has it's own interface
and there is an obvious way to find the interface from the PID.

Shared directories like /run and /tmp can let a process expose generic
file interfaces but there is no relation between the PID and exposed
interface. A process can create a file or directory such as
/tmp/${SERVICE}-${PID} but then that process is vulnerable to DOS
attacks by other users. Furthermore, the files are not removed on
process exit.

An object registry like DBus seems like a natural fit for this problem
but is oriented primarily towards services and not processes. There
are basically the same problems as with the shared directory
solution. As well, DBus is far too complicated when one just wants to
expose a socket interface. Moreover, there is no relation to the name
the process registers under and the PID.

A problem with "public process scoped interfaces" is that on process
exit the directory and all it's contents would be removed. This is
contrary to the semantics of rmdir which requires the directory to be
empty.

Final note, for a bit of speed and for letting /proc not be mounted
it could be convenient to create a system call, process_run_dir, that
takes a PID and opens the run directory for the process.

Thank you, Steven Stewart-Gallus

