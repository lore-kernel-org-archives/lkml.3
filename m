Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaACRKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:10:38 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53453 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbaACRKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:10:37 -0500
Message-ID: <1388769034.20141.11.camel@x220>
Subject: [PATCH] mei: mei-amt-version: remove unneeded call of mei_deinit()
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 18:10:34 +0100
In-Reply-To: <9629.1388766864@warthog.procyon.org.uk>
References: <1388766184.20141.6.camel@x220>
	 <20140103160812.8153.74401.stgit@warthog.procyon.org.uk>
	 <9629.1388766864@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2014 17:10:35.0324 (UTC) FILETIME=[B77FE7C0:01CF08A6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-03 at 16:34 +0000, David Howells wrote:
> Paul Bolle <pebolle@tiscali.nl> wrote:
> > But it turns out that call of mei_deinit() isn't needed at all. All of
> > the members of mei_cl will be set later in mei_init() and none will be
> > used before they are set. So we can simply drop this call of
> > mei_deinit()."
> > 
> > Is that analysis (still) correct?
> 
> It looks true as the code stands.  Can you send me your patch?

Sure. Below the scissors (hope I've typed those correctly).


Paul Bolle
-------->8------- 
From: Paul Bolle <pebolle@tiscali.nl>

Building mei-amt-version.o triggers a GCC warning:
    Documentation/misc-devices/mei/mei-amt-version.c: In function 'main':
    Documentation/misc-devices/mei/mei-amt-version.c:103:5: warning: 'acmd.fd' is used uninitialized in this function [-Wuninitialized]
      if (cl->fd != -1)
         ^
    Documentation/misc-devices/mei/mei-amt-version.c:443:21: note: 'acmd.fd' was declared here
      struct amt_host_if acmd;
                         ^

GCC is correct. See, the call chain that GCC detects must be
    main()
        amt_host_if_init()
            mei_init()
                mei_deinit()

But when we enter mei_deinit() struct amt_host_if acmd is still
unitialized. That makes the test for (effectively) amt_host_if->mei_cl->fd
bogus.

But it turns out that call of mei_deinit() isn't needed at all. All of
the members of mei_cl will be set later in mei_init() and none will be
used before they are set. So we can simply drop this call of
mei_deinit().

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/misc-devices/mei/mei-amt-version.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei-amt-version.c b/Documentation/misc-devices/mei/mei-amt-version.c
index 49e4f77..57d0d87 100644
--- a/Documentation/misc-devices/mei/mei-amt-version.c
+++ b/Documentation/misc-devices/mei/mei-amt-version.c
@@ -115,8 +115,6 @@ static bool mei_init(struct mei *me, const uuid_le *guid,
 	struct mei_client *cl;
 	struct mei_connect_client_data data;
 
-	mei_deinit(me);
-
 	me->verbose = verbose;
 
 	me->fd = open("/dev/mei", O_RDWR);
-- 
1.8.4.2

