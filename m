Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaCMNss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaCMNso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:48:44 -0400
Date: Thu, 13 Mar 2014 09:48:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Cong Wang <cwang@twopensource.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, tj@kernel.org, ssorce@redhat.com,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
Message-ID: <20140313134840.GA18914@redhat.com>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
 <1394657163-7472-3-git-send-email-vgoyal@redhat.com>
 <CAHA+R7OrNoa7_J-rOskxgdvkM5gAnQyoFBeCXSziY7XMd-yLNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHA+R7OrNoa7_J-rOskxgdvkM5gAnQyoFBeCXSziY7XMd-yLNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:58:57PM -0700, Cong Wang wrote:
> On Wed, Mar 12, 2014 at 1:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > @@ -1098,6 +1135,16 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
> >         if (newsk == NULL)
> >                 goto out;
> >
> > +       err = init_peercgroup(newsk);
> > +       if (err)
> > +               goto out;
> > +
> > +       err = alloc_cgroup_path(sk);
> > +       if (err)
> > +               goto out;
> > +
> > +       err = -ENOMEM;
> > +
> 
> Don't we need to free the cgroup_path on error path
> in this function?

Previous allocated cgroup_path is now in newsk->cgroup_path and I was
relying on __sk_free() freeing that memory if error happens.

unix_release_sock(sk)
  sock_put()
    sk_free()
      __sk_free()
        kfree(sk->cgroup_path)

Do you see a problem with that?

Thanks
Vivek
