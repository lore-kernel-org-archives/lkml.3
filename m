Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbbA2BiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:38:14 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:46976 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbbA2BiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:38:11 -0500
Message-ID: <54C912E8.5060606@lwfinger.net>
Date: Wed, 28 Jan 2015 10:48:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Heba Aamer <heba93aamer@gmail.com>, devel@driverdev.osuosl.org
CC: florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, thomas@grouk.net,
        sudipm.mukherjee@gmail.com, rickard_strandqvist@spectrumdigital.se,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: fix Prefer ether_addr_copy() over memcpy()
References: <20150128155325.GA18123@mohammed-Inspiron-3537>
In-Reply-To: <20150128155325.GA18123@mohammed-Inspiron-3537>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 09:53 AM, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl warning:
> Prefer ether_addr_copy() over memcpy()
> if the Ethernet addresses are __aligned(2)
>
> I used the following coccinelle script:
>
> @@
> expression E1,E2;constant E3;
> @@
>
> - memcpy(E1, E2, E3)
> + ether_addr_copy(E1, E2)
>
>
> pahole showed that the used structs are aligned to u16.

I think you can stop here. The commit message is much too long for a 2-line patch.

BTW, have you tested this patch? In particular, it needs to be tested on an 
architecture where alignment is important. Using x86 is not sufficient. The 
reason I ask is that there have been a lot of patches lately that change locking 
and alignment issues that are only build tested, and have never been tested with 
real hardware on any platform.

One other thing, checkpatch only suggests that this change should be made. It is 
certainly not mandatory. As you have not indicated that it has been tested,

NACK

Larry

>
> struct _adapter {
> 	struct dvobj_priv          dvobjpriv;            /*     0    40 */
> 	struct mlme_priv           mlmepriv;             /*    40  1560 */
> 	/* --- cacheline 25 boundary (1600 bytes) --- */
> 	struct cmd_priv            cmdpriv;              /*  1600   136 */
> 	/* --- cacheline 27 boundary (1728 bytes) was 8 bytes ago --- */
> 	struct evt_priv            evtpriv;              /*  1736    96 */
> 	/* --- cacheline 28 boundary (1792 bytes) was 40 bytes ago --- */
> 	struct io_queue *          pio_queue;            /*  1832     8 */
> 	struct xmit_priv           xmitpriv;             /*  1840   912 */
> 	/* --- cacheline 43 boundary (2752 bytes) --- */
> 	struct recv_priv           recvpriv;             /*  2752  1088 */
> 	/* --- cacheline 60 boundary (3840 bytes) --- */
> 	struct sta_priv            stapriv;              /*  3840   672 */
> 	/* --- cacheline 70 boundary (4480 bytes) was 32 bytes ago --- */
> 	struct security_priv       securitypriv;         /*  4512  4816 */
> 	/* --- cacheline 145 boundary (9280 bytes) was 48 bytes ago --- */
> 	struct registry_priv       registrypriv;         /*  9328   968 */
> 	/* --- cacheline 160 boundary (10240 bytes) was 56 bytes ago --- */
> 	struct wlan_acl_pool       acl_list;             /* 10296  1536 */
> 	/* --- cacheline 184 boundary (11776 bytes) was 56 bytes ago --- */
> 	struct pwrctrl_priv        pwrctrlpriv;          /* 11832   224 */
> 	/* --- cacheline 188 boundary (12032 bytes) was 24 bytes ago --- */
> 	struct eeprom_priv         eeprompriv;           /* 12056   508 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	/* --- cacheline 196 boundary (12544 bytes) was 24 bytes ago --- */
> 	struct hal_priv            halpriv;              /* 12568    88 */
> 	/* --- cacheline 197 boundary (12608 bytes) was 48 bytes ago --- */
> 	struct led_priv            ledpriv;              /* 12656   304 */
> 	/* --- cacheline 202 boundary (12928 bytes) was 32 bytes ago --- */
> 	struct mp_priv             mppriv;               /* 12960  1080 */
> 	/* --- cacheline 219 boundary (14016 bytes) was 24 bytes ago --- */
> 	s32                        bDriverStopped;       /* 14040     4 */
> 	s32                        bSurpriseRemoved;     /* 14044     4 */
> 	u32                        IsrContent;           /* 14048     4 */
> 	u32                        ImrContent;           /* 14052     4 */
> 	u8                         EepromAddressSize;    /* 14056     1 */
> 	u8                         hw_init_completed;    /* 14057     1 */
>
> 	/* XXX 6 bytes hole, try to pack */
>
> 	struct task_struct *       cmdThread;            /* 14064     8 */
> 	pid_t                      evtThread;            /* 14072     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	/* --- cacheline 220 boundary (14080 bytes) --- */
> 	struct task_struct *       xmitThread;           /* 14080     8 */
> 	pid_t                      recvThread;           /* 14088     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	uint                       (*dvobj_init)(struct _adapter *); /* 14096     8 */
> 	void                       (*dvobj_deinit)(struct _adapter *); /* 14104     8 */
> 	struct net_device *        pnetdev;              /* 14112     8 */
> 	int                        bup;                  /* 14120     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	struct net_device_stats    stats;                /* 14128   184 */
> 	/* --- cacheline 223 boundary (14272 bytes) was 40 bytes ago --- */
> 	struct iw_statistics       iwstats;              /* 14312    32 */
> 	/* --- cacheline 224 boundary (14336 bytes) was 8 bytes ago --- */
> 	int                        pid;                  /* 14344     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	struct work_struct         wkFilterRxFF0;        /* 14352    32 */
> 	u8                         blnEnableRxFF0Filter; /* 14384     1 */
>
> 	/* XXX 3 bytes hole, try to pack */
>
> 	spinlock_t                 lockRxFF0Filter;      /* 14388     4 */
> 	const struct firmware  *   fw;                   /* 14392     8 */
> 	/* --- cacheline 225 boundary (14400 bytes) --- */
> 	struct usb_interface *     pusb_intf;            /* 14400     8 */
> 	struct mutex               mutex_start;          /* 14408    40 */
>
> 	/* XXX last struct has 4 bytes of padding */
>
> 	struct completion          rtl8712_fw_ready;     /* 14448    32 */
> 	/* --- cacheline 226 boundary (14464 bytes) was 16 bytes ago --- */
>
> 	/* size: 14480, cachelines: 227, members: 40 */
> 	/* sum members: 14451, holes: 7, sum holes: 29 */
> 	/* paddings: 1, sum paddings: 4 */
> 	/* last cacheline: 16 bytes */
> };
>
> struct eeprom_priv {
> 	u8                         bautoload_fail_flag;  /*     0     1 */
> 	u8                         bempty;               /*     1     1 */
> 	u8                         sys_config;           /*     2     1 */
> 	u8                         mac_addr[6];          /*     3     6 */
> 	u8                         config0;              /*     9     1 */
> 	u16                        channel_plan;         /*    10     2 */
> 	u8                         country_string[3];    /*    12     3 */
> 	u8                         tx_power_b[15];       /*    15    15 */
> 	u8                         tx_power_g[15];       /*    30    15 */
> 	u8                         tx_power_a[201];      /*    45   201 */
> 	/* --- cacheline 3 boundary (192 bytes) was 54 bytes ago --- */
> 	u8                         efuse_eeprom_data[256]; /*   246   256 */
>
> 	/* XXX 2 bytes hole, try to pack */
>
> 	/* --- cacheline 7 boundary (448 bytes) was 56 bytes ago --- */
> 	enum RT_CUSTOMER_ID        CustomerID;           /*   504     4 */
>
> 	/* size: 508, cachelines: 8, members: 12 */
> 	/* sum members: 506, holes: 1, sum holes: 2 */
> 	/* last cacheline: 60 bytes */
> };
>
> struct net_device {
> 	char                       name[16];             /*     0    16 */
> 	struct hlist_node          name_hlist;           /*    16    16 */
> 	char *                     ifalias;              /*    32     8 */
> 	long unsigned int          mem_end;              /*    40     8 */
> 	long unsigned int          mem_start;            /*    48     8 */
> 	long unsigned int          base_addr;            /*    56     8 */
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	int                        irq;                  /*    64     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	long unsigned int          state;                /*    72     8 */
> 	struct list_head           dev_list;             /*    80    16 */
> 	struct list_head           napi_list;            /*    96    16 */
> 	struct list_head           unreg_list;           /*   112    16 */
> 	/* --- cacheline 2 boundary (128 bytes) --- */
> 	struct list_head           close_list;           /*   128    16 */
> 	struct {
> 		struct list_head   upper;                /*   144    16 */
> 		struct list_head   lower;                /*   160    16 */
> 	} adj_list;                                      /*   144    32 */
> 	struct {
> 		struct list_head   upper;                /*   176    16 */
> 		struct list_head   lower;                /*   192    16 */
> 	} all_adj_list;                                  /*   176    32 */
> 	/* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */
> 	netdev_features_t          features;             /*   208     8 */
> 	netdev_features_t          hw_features;          /*   216     8 */
> 	netdev_features_t          wanted_features;      /*   224     8 */
> 	netdev_features_t          vlan_features;        /*   232     8 */
> 	netdev_features_t          hw_enc_features;      /*   240     8 */
> 	netdev_features_t          mpls_features;        /*   248     8 */
> 	/* --- cacheline 4 boundary (256 bytes) --- */
> 	int                        ifindex;              /*   256     4 */
> 	int                        iflink;               /*   260     4 */
> 	struct net_device_stats    stats;                /*   264   184 */
> 	/* --- cacheline 7 boundary (448 bytes) --- */
> 	atomic_long_t              rx_dropped;           /*   448     8 */
> 	atomic_long_t              tx_dropped;           /*   456     8 */
> 	atomic_t                   carrier_changes;      /*   464     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	const struct iw_handler_def  * wireless_handlers; /*   472     8 */
> 	struct iw_public_data *    wireless_data;        /*   480     8 */
> 	const struct net_device_ops  * netdev_ops;       /*   488     8 */
> 	const struct ethtool_ops  * ethtool_ops;         /*   496     8 */
> 	const struct forwarding_accel_ops  * fwd_ops;    /*   504     8 */
> 	/* --- cacheline 8 boundary (512 bytes) --- */
> 	const struct header_ops  * header_ops;           /*   512     8 */
> 	unsigned int               flags;                /*   520     4 */
> 	unsigned int               priv_flags;           /*   524     4 */
> 	short unsigned int         gflags;               /*   528     2 */
> 	short unsigned int         padded;               /*   530     2 */
> 	unsigned char              operstate;            /*   532     1 */
> 	unsigned char              link_mode;            /*   533     1 */
> 	unsigned char              if_port;              /*   534     1 */
> 	unsigned char              dma;                  /*   535     1 */
> 	unsigned int               mtu;                  /*   536     4 */
> 	short unsigned int         type;                 /*   540     2 */
> 	short unsigned int         hard_header_len;      /*   542     2 */
> 	short unsigned int         needed_headroom;      /*   544     2 */
> 	short unsigned int         needed_tailroom;      /*   546     2 */
> 	unsigned char              perm_addr[32];        /*   548    32 */
> 	/* --- cacheline 9 boundary (576 bytes) was 4 bytes ago --- */
> 	unsigned char              addr_assign_type;     /*   580     1 */
> 	unsigned char              addr_len;             /*   581     1 */
> 	short unsigned int         neigh_priv_len;       /*   582     2 */
> 	short unsigned int         dev_id;               /*   584     2 */
> 	short unsigned int         dev_port;             /*   586     2 */
> 	spinlock_t                 addr_list_lock;       /*   588     4 */
> 	struct netdev_hw_addr_list uc;                   /*   592    24 */
> 	struct netdev_hw_addr_list mc;                   /*   616    24 */
> 	/* --- cacheline 10 boundary (640 bytes) --- */
> 	struct netdev_hw_addr_list dev_addrs;            /*   640    24 */
> 	struct kset *              queues_kset;          /*   664     8 */
> 	unsigned char              name_assign_type;     /*   672     1 */
> 	bool                       uc_promisc;           /*   673     1 */
>
> 	/* XXX 2 bytes hole, try to pack */
>
> 	unsigned int               promiscuity;          /*   676     4 */
> 	unsigned int               allmulti;             /*   680     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	struct vlan_info *         vlan_info;            /*   688     8 */
> 	struct dsa_switch_tree *   dsa_ptr;              /*   696     8 */
> 	/* --- cacheline 11 boundary (704 bytes) --- */
> 	struct tipc_bearer *       tipc_ptr;             /*   704     8 */
> 	void *                     atalk_ptr;            /*   712     8 */
> 	struct in_device *         ip_ptr;               /*   720     8 */
> 	struct dn_dev *            dn_ptr;               /*   728     8 */
> 	struct inet6_dev *         ip6_ptr;              /*   736     8 */
> 	void *                     ax25_ptr;             /*   744     8 */
> 	struct wireless_dev *      ieee80211_ptr;        /*   752     8 */
> 	struct wpan_dev *          ieee802154_ptr;       /*   760     8 */
> 	/* --- cacheline 12 boundary (768 bytes) --- */
> 	long unsigned int          last_rx;              /*   768     8 */
> 	unsigned char *            dev_addr;             /*   776     8 */
> 	struct netdev_rx_queue *   _rx;                  /*   784     8 */
> 	unsigned int               num_rx_queues;        /*   792     4 */
> 	unsigned int               real_num_rx_queues;   /*   796     4 */
> 	long unsigned int          gro_flush_timeout;    /*   800     8 */
> 	rx_handler_func_t *        rx_handler;           /*   808     8 */
> 	void *                     rx_handler_data;      /*   816     8 */
> 	struct netdev_queue *      ingress_queue;        /*   824     8 */
> 	/* --- cacheline 13 boundary (832 bytes) --- */
> 	unsigned char              broadcast[32];        /*   832    32 */
>
> 	/* XXX 32 bytes hole, try to pack */
>
> 	/* --- cacheline 14 boundary (896 bytes) --- */
> 	struct netdev_queue *      _tx;                  /*   896     8 */
> 	unsigned int               num_tx_queues;        /*   904     4 */
> 	unsigned int               real_num_tx_queues;   /*   908     4 */
> 	struct Qdisc *             qdisc;                /*   912     8 */
> 	long unsigned int          tx_queue_len;         /*   920     8 */
> 	spinlock_t                 tx_global_lock;       /*   928     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	struct xps_dev_maps *      xps_maps;             /*   936     8 */
> 	struct cpu_rmap *          rx_cpu_rmap;          /*   944     8 */
> 	long unsigned int          trans_start;          /*   952     8 */
> 	/* --- cacheline 15 boundary (960 bytes) --- */
> 	int                        watchdog_timeo;       /*   960     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	struct timer_list          watchdog_timer;       /*   968    80 */
> 	/* --- cacheline 16 boundary (1024 bytes) was 24 bytes ago --- */
> 	int *                      pcpu_refcnt;          /*  1048     8 */
> 	struct list_head           todo_list;            /*  1056    16 */
> 	struct hlist_node          index_hlist;          /*  1072    16 */
> 	/* --- cacheline 17 boundary (1088 bytes) --- */
> 	struct list_head           link_watch_list;      /*  1088    16 */
> 	enum {
> 		NETREG_UNINITIALIZED = 0,
> 		NETREG_REGISTERED = 1,
> 		NETREG_UNREGISTERING = 2,
> 		NETREG_UNREGISTERED = 3,
> 		NETREG_RELEASED = 4,
> 		NETREG_DUMMY = 5,
> 	} reg_state:8;                                     /*  1104     4 */
>
> 	/* Bitfield combined with next fields */
>
> 	bool                       dismantle;            /*  1105     1 */
>
> 	/* Bitfield combined with previous fields */
>
> 	enum {
> 		RTNL_LINK_INITIALIZED = 0,
> 		RTNL_LINK_INITIALIZING = 1,
> 	} rtnl_link_state:16;                               /*  1104     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	void                       (*destructor)(struct net_device *); /*  1112     8 */
> 	struct netpoll_info *      npinfo;               /*  1120     8 */
> 	struct net *               nd_net;               /*  1128     8 */
> 	union {
> 		void *             ml_priv;              /*           8 */
> 		struct pcpu_lstats * lstats;             /*           8 */
> 		struct pcpu_sw_netstats * tstats;        /*           8 */
> 		struct pcpu_dstats * dstats;             /*           8 */
> 		struct pcpu_vstats * vstats;             /*           8 */
> 	};                                               /*  1136     8 */
> 	struct garp_port *         garp_port;            /*  1144     8 */
> 	/* --- cacheline 18 boundary (1152 bytes) was 4 bytes ago --- */
> 	struct mrp_port *          mrp_port;             /*  1152     8 */
> 	struct device              dev;                  /*  1160   688 */
>
> 	/* XXX last struct has 7 bytes of padding */
>
> 	/* --- cacheline 28 boundary (1792 bytes) was 60 bytes ago --- */
> 	const struct attribute_group  * sysfs_groups[4]; /*  1848    32 */
> 	/* --- cacheline 29 boundary (1856 bytes) was 28 bytes ago --- */
> 	const struct attribute_group  * sysfs_rx_queue_group; /*  1880     8 */
> 	const struct rtnl_link_ops  * rtnl_link_ops;     /*  1888     8 */
> 	unsigned int               gso_max_size;         /*  1896     4 */
> 	u16                        gso_max_segs;         /*  1900     2 */
> 	u16                        gso_min_segs;         /*  1902     2 */
> 	const struct dcbnl_rtnl_ops  * dcbnl_ops;        /*  1904     8 */
> 	u8                         num_tc;               /*  1912     1 */
>
> 	/* XXX 1 byte hole, try to pack */
>
> 	struct netdev_tc_txq       tc_to_txq[16];        /*  1914    64 */
> 	/* --- cacheline 30 boundary (1920 bytes) was 62 bytes ago --- */
> 	u8                         prio_tc_map[16];      /*  1978    16 */
>
> 	/* XXX 2 bytes hole, try to pack */
>
> 	/* --- cacheline 31 boundary (1984 bytes) was 16 bytes ago --- */
> 	unsigned int               fcoe_ddp_xid;         /*  1996     4 */
> 	struct phy_device *        phydev;               /*  2000     8 */
> 	struct lock_class_key *    qdisc_tx_busylock;    /*  2008     8 */
> 	int                        group;                /*  2016     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	struct pm_qos_request      pm_qos_req;           /*  2024   176 */
> 	/* --- cacheline 34 boundary (2176 bytes) was 28 bytes ago --- */
>
> 	/* size: 2240, cachelines: 35, members: 120 */
> 	/* sum members: 2139, holes: 11, sum holes: 65 */
> 	/* padding: 40 */
> 	/* paddings: 1, sum paddings: 7 */
>
> 	/* BRAIN FART ALERT! 2240 != 2139 + 65(holes), diff = 36 */
>
> };
>
> Moreover mac and pdata are simple arrays and pointers.
>
> Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
> ---
>   drivers/staging/rtl8712/usb_intf.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
> index 15f0d42..a2f2dfb 100644
> --- a/drivers/staging/rtl8712/usb_intf.c
> +++ b/drivers/staging/rtl8712/usb_intf.c
> @@ -463,7 +463,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
>   				/* Use the mac address stored in the Efuse
>   				 * offset = 0x12 for usb in efuse
>   				 */
> -				memcpy(mac, &pdata[0x12], ETH_ALEN);
> +				ether_addr_copy(mac, &pdata[0x12]);
>   			}
>   			eeprom_CustomerID = pdata[0x52];
>   			switch (eeprom_CustomerID) {
> @@ -580,7 +580,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
>   		} else
>   			dev_info(&udev->dev,
>   				"r8712u: MAC Address from efuse = %pM\n", mac);
> -		memcpy(pnetdev->dev_addr, mac, ETH_ALEN);
> +		ether_addr_copy(pnetdev->dev_addr, mac);
>   	}
>   	/* step 6. Load the firmware asynchronously */
>   	if (rtl871x_load_fw(padapter))
>

