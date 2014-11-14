Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161011AbaKNL2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:28:52 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36076 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbaKNL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:28:49 -0500
Message-ID: <1415964471.9159.11.camel@vamsip>
Subject: WSMP(Wave Short Message Protocol)  Stack Implementation
From: vamsi <vamsi07450@gmail.com>
To: linux-wireless@vger.kernel.org, hernan.gonzalez.calderon@gmail.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        lisovy@gmail.com, fengguang.wu@intel.com, rostislav.lisovy@fel.cvut.cz
Cc: johannes@sipsolutions.net, Michal Sojka <sojkam1@fel.cvut.cz>,
        s.sander@nordsys.de, jan-niklas.meier@volkswagen.de,
        burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Liraz Perelmooter <liraz.perelmooter@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        s.sander@nordsys.de, jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
        "wireless-regdb@lists.infradead.org" 
	<wireless-regdb@lists.infradead.org>,
        Michael Green <green@qti.qualcomm.com>,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        Thierry Ernst <thierry.ernst@yogoko.fr>
Date: Fri, 14 Nov 2014 16:57:51 +0530
Content-Type: multipart/mixed; boundary="=-+KX9FLWEeDhl/ZcXDdme"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+KX9FLWEeDhl/ZcXDdme
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi  ,

 I am planing to develop WSMP (Wave Short Message Protocol) protocol in
transport layer.Any suggestions will be appreciated,

My idea is given below

WSMP(Wave Short Message Protocol ie. 1609.3
published by the IEEE Vehicular Society) is a part of the DSRC(Dedicated
Short Range Communications) standards suite which include 802.11p,
1609.x series. Which are used for "intervehicular communication" and
also for "vehicle to infrastructure communication".

The DSRC/WAVE stack:

         Application Layer (SAE J2735 Message set dictionary)

                ^
                |
         Transport Layer -|
                ^         |
                |         |--(WSMP IEEE 1609.3) Both combined
         Network Layer    |
                ^         |
                |         |
         LLC(existing)   -|
                ^
                |
         Datalink Layer  -|
                ^         |
                |         |--(1609.4 and IEEE802.11p)
         Physical Layer  -|


Currently as IEEE 802.11-2012 has released,it is having 802.11p also
merged in it.
We may have WSMP acting as both transport layer and network layer.We
have some proprietry
implementations of all these standards but no open source implementation
has been done.

We propose to develop this in a way so that it has a socket interface to
the user.
Please give your suggestions.
For more info regarding the stack one may refer to the Document
IEEE1609.0 or John Kenney's
paper on this subject "Dedicated Short-Range
Communications (DSRC) Standards in the United States"
link  "http://secs.oakland.edu/~gpcorser/vanet-kenny-DSRC.pdf"

      * Following attachments are my source code of transport layer
        please give me suggestion.

I added following attachment only transmission function but
unfortunately this packet is discarded in hardware please help me.


Thanks & Regards,
Vamsi

--=-+KX9FLWEeDhl/ZcXDdme
Content-Disposition: attachment; filename="wsmp.h"
Content-Type: text/x-chdr; name="wsmp.h"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

MODULE_LICENSE("GPL");
#include <net/inet_sock.h>

#define WSMP_HDR_SIZE 16
#ifndef AF_WSMP

#define AF_WSMP    44
#define PF_WSMP    AF_WSMP
#endif

#define wsmp_sk(__sk) ((struct wsmp_sock *) __sk)

struct wsmp_sock {
	struct inet_sock inet;
	struct list_head accept_q;
	u16 wsmp_heder_length;
	
	__be16 num; //protocol number
};
extern  struct proto_ops wsmp_sock_ops;


struct wsmphdr {
       __u8 wsm_version;
       __u8 security_type;
       __u8 cno;
       __u8 data_rate;
       __u8 tx_pow_level;
       __u32 psid;
       __u16 wsm_length;
       uint8_t *data;
};








struct sockaddr_wsmp {
	__u16 sin_family;
	__u8  wsm_version;
	__u8  security_type;
	__u8  cno;
	__u8  data_rate;
	__u8  tx_pow_level;
	__u32 psid;
	__u16 wsm_length;
};
	


--=-+KX9FLWEeDhl/ZcXDdme
Content-Disposition: attachment; filename="wsmp.c"
Content-Type: text/x-csrc; name="wsmp.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * This file implement the WSMP(Wave Short Message Protocol)  priv API.
 *
 * Authors :	Tata P Vamsi Krishna <vamsi07450@gmail.com>
 * Copyright	2014 Tata P Vamsi Krishna <vamsi07450@gmail.com>
 *
 * (As all part of the Linux kernel, this file is GPL)
 */
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/debugfs.h>
#include <linux/seq_file.h>
#include <linux/module.h>
#include <asm/ioctls.h>
#include <linux/proc_fs.h>
#include <linux/socket.h>
#include <linux/net.h>
#include <net/sock.h>
#include"wsmp.h"

static void wsmp_sock_kill(struct sock *sk);
 
static int wsmp_sock_shutdown(struct socket *sock, int how)
{	struct sock *sk = sock->sk;
	int err = 0;

	

	if (!sk)
		return 0;

	if (!sk->sk_shutdown) 
		sk->sk_shutdown = SHUTDOWN_MASK;
	//	__rfcomm_sock_close(sk);

		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
		//	err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
	
	release_sock(sk);
	printk("This is wsmp_sock_shutdown\n");
	return err;
	
	

}

static int wsmp_sock_release(struct socket *sock)
{	
	struct sock *sk = sock->sk;
	int err = 0;
	if (!sk)
		return 0;
	wsmp_sock_shutdown(sock,2);
	sock_orphan(sk);
	wsmp_sock_kill(sk);
	printk("This is wsmp_sock_release..\n");
	return 0;
}

static void wsmp_sock_kill(struct sock *sk){

	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
		return;

	sock_set_flag(sk, SOCK_DEAD);
	sock_put(sk);
	printk("This is wsmp_sock_kill..\n");
}



static int wsmp_sock_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
{
	 struct sockaddr_in *addr = (struct sockaddr_in *)uaddr;
         struct sock *sk = sock->sk;
         struct inet_sock *inet = inet_sk(sk);
         struct net *net = sock_net(sk);
         unsigned short snum;
         int chk_addr_ret;
         int err,i;
 
         /* If the socket has its own bind function then use it. (RAW) */
         if (sk->sk_prot->bind) {
                 err = sk->sk_prot->bind(sk, uaddr, addr_len);
               printk("error message");;
         }
	printk("This family....%d\n",uaddr->sa_family);
	printk("This address: ");
	for(i=0;i<14;i++)
		printk("%d ",uaddr->sa_data[i]);
	
	printk("\n");

	printk("This is wsmp_sock_bind..\n");
	return 0;
}

static int wsmp_sock_connect(struct socket *sock, struct sockaddr *addr, int alen, int flags)
{
	printk("This is wsmp_sock_connect..\n");
	return 0;
}
static int wsmp_sock_listen(struct socket *sock, int backlog)
{
	printk("This is wsmp_sock_listen\n");
	return 0;
}

static int wsmp_sock_accept(struct socket *sock, struct socket *newsock, int flags)
{
	printk("This is wsmp_sock_accept\n");
	return 0;
}

static int wsmp_sock_getname(struct socket *sock, struct sockaddr *addr, int *len, int peer)
{
	printk("This is wsmp_sock_getname\n");
	return 0;
}


static int wsmp_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
			    struct msghdr *msg, size_t len)
{	
	struct sock *sk = sock->sk;

        return sk->sk_prot->sendmsg(iocb, sk, msg, len);
}


int wsmp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
				struct msghdr *msg, size_t len, int flags)
{
	printk("This is wsmp_sock_recvmsg\n");
	return 0;
}



int wsmp_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
{
	printk("This is wsmp_sock_ioctl\n");
	return 0;
}



struct proto_ops wsmp_sock_ops = {
	.family		= PF_WSMP,
	.owner		= THIS_MODULE,
	.release	= wsmp_sock_release,
	.bind		= wsmp_sock_bind,
	.connect	= wsmp_sock_connect,
	.listen		= wsmp_sock_listen,
	.accept		= wsmp_sock_accept,
	.getname	= wsmp_sock_getname,
	.sendmsg	= wsmp_sock_sendmsg,
	.recvmsg	= wsmp_sock_recvmsg,
	.ioctl		= wsmp_sock_ioctl,
	.mmap		= sock_no_mmap,
	.socketpair	= sock_no_socketpair,
	.shutdown	= wsmp_sock_shutdown,
};

MODULE_LICENSE("GPL");

--=-+KX9FLWEeDhl/ZcXDdme
Content-Disposition: attachment; filename="af_wsmp.c"
Content-Type: text/x-csrc; name="af_wsmp.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * This file implement the WSMP(Wave Short Message Protocol)  priv API.
 *
 * Authors :	Tata P Vamsi Krishna <vamsi07450@gmail.com>
 * Copyright	2014 Tata P Vamsi Krishna <vamsi07450@gmail.com>
 *
 * (As all part of the Linux kernel, this file is GPL)
 */


#include <linux/module.h>
#include <asm/ioctls.h>
#include "wsmp.h"
#include <linux/proc_fs.h>
#include <linux/socket.h>
#include <linux/net.h>
#include <net/sock.h>
#include<linux/init.h>
#include <linux/netdevice.h>


static void wsmp_setup(struct net_device *dev)
{
	
}

 

static void wsmp_proto_sendmsg(struct kiocb *iocb, struct sock *sk,struct msghdr *msg, size_t len)
{
	struct net_device *dev;
     //   unsigned int mtu;
        struct sk_buff *skb;
	int i;
	//__be16 proto;
	//struct wsmp_sock *wsmpo = wsmp_sk(sk);
	//struct dgram_sock *ro = dgram_sk(sk);
	//unsigned char * data;
	struct wsmphdr wsmp_hdr;
	int err,hlen,tlen;
	
	
	//DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
	
	//printk("\nprotocol number%d \n",saddr->sll_protocol);
	//dev = alloc_netdev(0,"wlan0",wsmp_setup);
	dev=__dev_get_by_name(&init_net,"wlan0");
	
	if (!dev) {
		printk("alloc_netdev failed\n");
	}
	

	hlen = LL_RESERVED_SPACE(dev);
	tlen = dev->needed_tailroom;
	wsmp_hdr.wsm_version=2;
	wsmp_hdr.security_type=5;
	wsmp_hdr.cno=100;
	wsmp_hdr.data_rate=24;
	wsmp_hdr.tx_pow_level=48;
	wsmp_hdr.psid=14;
	wsmp_hdr.wsm_length=114;

	skb = sock_alloc_send_skb(sk, 237,
                        msg->msg_flags & MSG_DONTWAIT,
                        &err);

	printk("len ............%d..............\n",hlen+tlen+len+WSMP_HDR_SIZE);
        if (!skb)
                printk("error occuring allocation of sk_buff");
	
        skb_reserve(skb, hlen);

	
	skb_reset_network_header(skb);
	
	

	printk("wsmp_proto_sendmsg....%s......%d....\n",msg->msg_iov->iov_base,msg->msg_iov->iov_len);
	
	

        err = memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len);
        if (err < 0) {
		printk("memcpy_fromiovec");
		return;
	}

	printk("---------%s------\n",skb->data);
	printk("-----len:----%d---data:- %s--%x....%d...%d\n",dev->mtu,dev->name,dev->dev_addr[1],hlen,tlen);
	skb_push(skb, WSMP_HDR_SIZE);
	printk("---------%s------\n",skb->data);
        skb_reset_transport_header(skb);
        memcpy(skb_transport_header(skb), &wsmp_hdr, WSMP_HDR_SIZE);
               // goto out_skb;
	
        skb->dev = dev;
        skb->sk  = sk;
       skb->protocol = htons(0x88dc);
	
      	printk(".....%d.....%x",skb->protocol,skb->protocol);
	
	

	printk("wsmp_proto_sendmsg. return:%d.. data:%s..len:%d.. \n",err,skb->data,skb->len);
   	err = dev_queue_xmit(skb);
	
	printk("wsmp_proto_sendmsg. return:%d.. data:%s..len:%d.. \n",err,skb->data,skb->len);
    	if (err < 0) {
		printk("dev_queue_xmit");
		return;
	}
         

	  dev_put(dev);
	for (i=0; i < skb->len; i++)
		printk("%02x ",skb->data[i]);
	printk("\n....wsmp_proto_sendmsg\n");

}

static struct proto wsmp_proto = {
	.name		= "WSMP",
	.owner		= THIS_MODULE,
	.obj_size	= sizeof(struct wsmp_sock),
	.sendmsg	= wsmp_proto_sendmsg,	
};

static struct sock *wsmp_sock_alloc(struct net *net, struct socket *sock, int proto, gfp_t prio)
{		
		struct sock *sk;

	sk = sk_alloc(net, PF_WSMP, prio, &wsmp_proto);
	if (!sk)
		return NULL;
	sock_init_data(sock, sk);
	INIT_LIST_HEAD(&wsmp_sk(sk)->accept_q);
	
	printk("this inside wsmp_sock_alloc..\n");
	return sk;
	
}


static void wsmp_sock_init(struct sock *sk, struct sock *parent)
{
	
	printk("I am inside wsmp_sock_init\n");
	if (parent) {
		sk->sk_type = parent->sk_type;
		security_sk_clone(parent, sk);
	}
}

static int wsmp_sock_create(struct net *net, struct socket *sock, int protocol,
			   int kern)
{
	struct sock *sk;

	printk("I am inside wsmp_sock_create..\n");

	sock->state = SS_UNCONNECTED;
	
	if (sock->type != SOCK_SEQPACKET&& sock->type != SOCK_STREAM&&
			sock->type != SOCK_DGRAM)
		return -ESOCKTNOSUPPORT;
	
	sock->ops = &wsmp_sock_ops;

	sk = wsmp_sock_alloc(net, sock, protocol, GFP_ATOMIC);
	if (!sk)
		return -ENOMEM;
	
	wsmp_sock_init(sk, NULL);
	
	return 0;
}

static struct net_proto_family wsmp_sock_family_ops = {
	.owner	= THIS_MODULE,
	.family	= PF_WSMP,
	.create	= wsmp_sock_create,
};




static int __init wsmp_init(void) {

	int err;
	printk("Inserting wsmp module..\n");

	err = sock_register(&wsmp_sock_family_ops);
	if (err < 0) {
		printk("sock_register failed\n");
		return err;
	} else		
	err = proto_register(&wsmp_proto, 1);
	if (err < 0) {
		printk("proto_register failed\n");
		goto err;
	}

err:
	//sock_unregister(PF_WSMP);

	return err;
}
void __exit wsmp_exit(void)
{
	sock_unregister(PF_WSMP);
	proto_unregister(&wsmp_proto);
}

module_init(wsmp_init);
module_exit(wsmp_exit);
MODULE_LICENSE("GPL");

--=-+KX9FLWEeDhl/ZcXDdme--

