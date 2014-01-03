Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaACQXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:23:34 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55475 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaACQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:23:07 -0500
Message-ID: <1388766184.20141.6.camel@x220>
Subject: Re: [PATCH 7/7] Fix uninitialised variable warning in
 mei-amt-version.c
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 17:23:04 +0100
In-Reply-To: <20140103160812.8153.74401.stgit@warthog.procyon.org.uk>
References: <20140103160812.8153.74401.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jan 2014 16:23:05.0493 (UTC) FILETIME=[14DE3450:01CF08A0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-03 at 16:08 +0000, David Howells wrote:
> Fix the following warning:
> 
> 	Documentation/misc-devices/mei/mei-amt-version.c: In function 'main':
> 	Documentation/misc-devices/mei/mei-amt-version.c:103:5: warning: 'acmd.fd' is used uninitialized in this function [-Wuninitialized]
> 	  if (cl->fd != -1)
> 	     ^
> 	Documentation/misc-devices/mei/mei-amt-version.c:443:21: note: 'acmd.fd' was declared here
> 	  struct amt_host_if acmd;
> 			     ^
> 
> The call chain:
> 
> 	-->main()
> 	   -->amt_host_if_init()
> 	      -->mei_init()
> 	         -->mei_deinit()
> 
> results in this on the first time through because main()::acmd has not yet
> been initialised.
> 
> To fix this, acmd.fd needs to be initialised to -1.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Tomas Winkler <tomas.winkler@intel.com>
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I've been using a local patch now for quite some time. I currently use
it on v3.12.6. I haven't yet bothered to submit it. My (draft) commit
summary reads:

"Building mei-amt-version.o triggers a GCC warning:
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
mei_deinit()."

Is that analysis (still) correct?


Paul Bolle

>  Documentation/misc-devices/mei/mei-amt-version.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/misc-devices/mei/mei-amt-version.c b/Documentation/misc-devices/mei/mei-amt-version.c
> index 49e4f770864a..7027a8da0ba0 100644
> --- a/Documentation/misc-devices/mei/mei-amt-version.c
> +++ b/Documentation/misc-devices/mei/mei-amt-version.c
> @@ -440,7 +440,7 @@ out:
>  int main(int argc, char **argv)
>  {
>  	struct amt_code_versions ver;
> -	struct amt_host_if acmd;
> +	struct amt_host_if acmd = { .mei_cl.fd = -1 };
>  	unsigned int i;
>  	uint32_t status;
>  	int ret;
> 


