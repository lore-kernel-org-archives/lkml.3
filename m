Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3LLKqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:46:08 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:48568 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3LLKqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:46:05 -0500
Message-ID: <1386845150.9959.3.camel@localhost.localdomain>
Subject: Re: [PATCH] fs: clear close-on-exec flag as part of put_unused_fd()
From: Yann Droneaud <ydroneaud@opteya.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 12 Dec 2013 11:45:50 +0100
In-Reply-To: <20131211223634.GA13828@mguzik.redhat.com>
References: <1386796107-4197-1-git-send-email-ydroneaud@opteya.com>
	 <20131211223634.GA13828@mguzik.redhat.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le mercredi 11 décembre 2013 à 23:36 +0100, Mateusz Guzik a écrit :
> On Wed, Dec 11, 2013 at 10:08:27PM +0100, Yann Droneaud wrote:
> > @@ -806,8 +803,6 @@ static int do_dup2(struct files_struct *files,
> >  	__set_open_fd(fd, fdt);
> >  	if (flags & O_CLOEXEC)
> >  		__set_close_on_exec(fd, fdt);
> > -	else
> > -		__clear_close_on_exec(fd, fdt);
> >  	spin_unlock(&files->file_lock);
> >  
> >  	if (tofree)
> 
> From my reading this will break at least the following:
> fd = open(..., .. | O_CLOEXEC);
> dup2(whatever, fd);
> 
> now fd has O_CLOEXEC even though it should not
> 

Thanks for the review.

You're right.

I've misunderstood the portion of the code handling the case where the
destination fd is already marked as used: -EBUSY is only returned when
the file descriptor is allocaged but not yet installed.

So close-on-exec flag must be cleared in do_dup2().

Regards.

-- 
Yann Droneaud
OPTEYA


